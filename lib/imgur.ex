defmodule Imgur do
  @content_type_pattern ~r/\/(.*)$/

  @spec get_image_extension(bitstring) :: bitstring
  def get_image_extension(source_url) do
    HTTPoison.start
    response = HTTPoison.get(source_url)
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, headers: headers}} ->
        image_filetype(headers)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Couldn't retrieve filetype for #{source_url}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
    HTTPoison.get(source_url)
    |> handle_response
  rescue
    KeyError -> {:error, :bad_resposne}
  end

  defp handle_response({:error, _error}), do: nil
  defp handle_response({:ok, response}) do
    Map.fetch!(response, :headers)
    |> image_filetype
  end

  defp image_filetype(headers_list) do
    Enum.find(headers_list, &(elem(&1, 0) == "Content-Type"))
    |> Kernel.elem(1)
    |> extract_filetype_from_content_type
  rescue
    ArgumentError -> nil
  end

  defp extract_filetype_from_content_type(nil), do: nil
  defp extract_filetype_from_content_type(content_type) do
    Regex.run(@content_type_pattern, content_type, [capture: :all_but_first])
    |> List.first
  end
end
