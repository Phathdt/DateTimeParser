defmodule DateTimeParser do
  def parse(date_string, format) do
    new_format = convert_format(format)

    try do
      [date, time, seconds] =
        String.split(date_string, " ")
        |> case do
          [date, time, zone] ->
            seconds = get_zone_second(zone)

            [date, time, seconds]

          [date, time] ->
            [date, time, 0]

          [date] ->
            [date, "", 0]
        end

      value =
        "#{date} #{time}"
        |> String.trim()
        |> Timex.parse!(new_format)
        |> Timex.to_datetime()
        |> DateTime.add(-seconds, :second)

      {:ok, value}
    rescue
      _ -> {:error, :error}
    end
  end

  defp get_zone_second(str) do
    with offset <- String.at(str, 0),
         hour <- String.slice(str, 1, 2) |> String.to_integer(),
         minute <- String.slice(str, 3, 4) |> String.to_integer() do
      if hour > 12 do
        raise "hour must be less than 12"
      end

      String.to_integer("#{offset}#{hour * 3600 + minute * 60}")
    end
  end

  @patterns [
    {"%d", "{0D}"},
    {"%M", "{0M}"},
    {"%Y", "{YYYY}"},
    {"%y", "{YY}"},
    {"%H", "{h24}"},
    {"%I", "{h12}"},
    {"%m", "{0m}"},
    {"%S", "{0s}"},
    {"%P", "{AM}"},
    {"%p", "{am}"},
    {"%z", ""}
  ]
  defp convert_format(format),
    do:
      @patterns
      |> Enum.reduce(format, fn {first, second}, acc ->
        String.replace(acc, first, second)
      end)
      |> String.trim()
end
