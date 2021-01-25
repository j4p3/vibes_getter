defmodule VibesGetter do
  @moduledoc """
  Retrieves vibes from various corners of the internet for processing and remixing.
  """

  @typedoc """
  Map of vibe attributes.
  """
  @type vibe_resonator :: %{
          title: bitstring,
          type: :image | :video | :text,
          media_url: bitstring,
          source: :reddit | nil,
          original_url: bitstring
        }


  @doc """
  Retrieves vibes from reddit
  """
  @spec reddit(charlist, integer) :: vibe_resonator
  def reddit(subreddit_name, quantity) do
    Reddit.Client.login()
    |> Reddit.Subreddit.top_posts(subreddit_name, limit: quantity, t: "all")
    |> handle_reddit_login
  end

  defp handle_reddit_login({:ok, response}), do: {:ok, response.body["data"]["children"]}
  defp handle_reddit_login({:error, response}), do: {:error, response.body}
end
