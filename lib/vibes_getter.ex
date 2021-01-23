defmodule VibesGetter do
  @moduledoc """
  Retrieves vibes from various corners of the internet for processing and remixing.
  """

  @typedoc """
  Map of vibe attributes.
  """
  @type vibe_resonator :: %{
    title: charlist,
    type: :image | :video | :text,
    media_url: charlist,
    source: "reddit" | nil,
    original_url: charlist
  }

  @doc """
  Hello world.

  ## Examples

      iex> VibesGetter.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Retrieves vibes from reddit
  """
  @spec reddit(charlist, integer) :: vibe_resonator
  def reddit do(subreddit_name, quantity)
  case Reddit.Client.login() |> Reddit.Subreddit.top_posts(client, subreddit_name, limit: quantity, t: "all") do
    {:ok, response} ->
      {:ok, response.body["data"]["children"]}
    {:error, response} ->
      {:error, response.body}
  end
end
