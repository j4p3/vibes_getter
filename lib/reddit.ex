defmodule Reddit do
  @moduledoc """
  Handler for Reddit vibes
  """

  @imgur_post_uri_pattern ~r/[a-z]\/(.*)$/
  @gyfcat_post_uri_pattern ~r/[a-z]\/(.*)\-size_restricted.gif$/

  @doc """
  Generate a vibe from a retrieved Reddit post.
  """
  @spec vibe_from_post(Map) :: VibesGetter.vibe_resonator()
  def vibe_from_post(post) do
    post_data = post["data"]

    %{
      title: post_data["title"],
      type: type_for_post(post_data),
      media_url: media_url_for_post(post_data),
      source: :reddit,
      original_source_url: "https://www.reddit.com#{post_data["permalink"]}"
    }
  end

  @spec media_url_for_post(Map) :: bitstring
  defp media_url_for_post(post_data) do
    case post_data["domain"] do
      "imgur.com" ->
        post_id = Map.get(post_data, "url_overridden_by_dest")
        |> extract_substring(@imgur_post_uri_pattern)
        file_extension = Imgur.get_image_extension("https://i.imgur.com/#{post_id}.jpg")
        "https://i.imgur.com/#{post_id}.#{file_extension}"

      "i.imgur.com" ->
        Map.get(post_data, "url_overridden_by_dest")

      "i.redd.it" ->
        Map.get(post_data, "url_overridden_by_dest")

      "gfycat.com" ->
        get_in(post_data, ["secure_media", "oembed", "thumbnail_url"])
        |> extract_substring(@gyfcat_post_uri_pattern)
        |> (&"https://giant.gyfcat.com/#{&1}.mp4").()

      "v.redd.it" ->
        get_in(post_data, ["secure_media", "reddit_video", "fallback_url"])
    end
  end

  @spec extract_substring(bitstring, %Regex{}) :: bitstring
  defp extract_substring(target_string, regex_pattern) do
    Regex.run(regex_pattern, target_string, capture: :all_but_first)
    |> List.first()
  end

  @spec type_for_post(Map) :: :nil | :video | :text | :image
  defp type_for_post(post_data) do
    cond do
      Map.fetch!(post_data, "is_video") == true ->
        :video

      Map.fetch!(post_data, "is_meta") == true ->
        :text

      Map.fetch!(post_data, "is_self") == true ->
        :text

      true ->
        :image
    end
  rescue
    KeyError ->
      :nil
  end
end
