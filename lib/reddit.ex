defmodule Reddit do
  @moduledoc """
  Handler for Reddit vibes
  """

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

  end

  @spec post_source(Map) :: atom
  defp post_source(post_data) do

  end

  @spec type_for_post(Map) :: atom
  defp type_for_post(post_data) do
    cond do
      post_data["is_video"] ->
        :video
      post_data["is_meta"] ->
        :text
      post_z
    end
    post_data["is_media"]
  end
end
