defmodule Reddit do
  @moduledoc """
  Handler for Reddit vibes
  """

  IMGUR_POST_URI_PATTERN = ~r/[a-z]\/(.*)$/
  GYFCAT_POST_URI_PATTERN = ~r/[a-z]\/(.*)\-size_restricted.gif$/

  # @spec vibe_from_post(Map) :: VibesGetter.vibe_resonator
  def vibe_from_post(post) do
    post_data = post["data"]
    %{
      title: post_data["title"],
      type: type_for_post(post_data),
      media_url: media_url_for_post(post_data),
      source: "reddit",
      original_source_url:
    }
  end

  @spec media_url_for_post(Map) :: charlist
  defp media_url_for_post(post_data) do
    case post_data["domain"] do
      "imgur.com" ->
        Map.get(post_data, "url_overridden_by_dest")
        |> extract_substring(IMGUR_POST_URI_PATTERN)
        |> &("https://i.imgur.com/#{&1}.jpg")
        # @todo: check response headers for filetype
      "i.imgur.com" ->
        Map.get(post_data, "url_overridden_by_dest")
      "i.redd.it" ->
        Map.get(post_data, "url_overridden_by_dest")
      "gfycat.com" ->
        get_in(post_data, "secure_media", "oembed", "thumbnail_url")
        |> extract_substring(GYFCAT_POST_URI_PATTERN)
        |> &("https://giant.gyfcat.com/#{&1}.mp4")
      "v.redd.it" ->
        get_in(post_data, "secure_media", "reddit_video", "fallback_url")
    end
  end

  defp extract_substring(target_string, regex_pattern) do
    Regex.run(regex_pattern, target_string, [capture: :all_but_first])
    |> List.first()
  end

  @spec type_for_post(Map) :: atom
  defp type_for_post(post_data) do
    cond do
      post_data["is_video"] ->
        :video
      post_data["is_meta"] ->
        :text
      post_data["is_self"] ->
        :text
    end
  end
end
