DateTimeParser Elixir


```elixir
cases = [
  {"2021-10-12", "%Y-%M-%d", ~U[2021-10-12 00:00:00Z]},
  {"02/10/2021", "%d/%M/%Y", ~U[2021-10-02 00:00:00Z]},
  {"10:07:22", "%H:%m:%S", ~U[0000-01-01 10:07:22Z]},
  {"10:15:10PM", "%I:%m:%S%P", ~U[0000-01-01 22:15:10Z]},
  {"10:15:10AM", "%I:%m:%S%P", ~U[0000-01-01 10:15:10Z]},
  {"12:15:10PM", "%I:%m:%S%P", ~U[0000-01-01 12:15:10Z]},
  {"22/12/21 11:00:55", "%d/%M/%y %H:%m:%S", ~U[2021-12-22 11:00:55Z]},
  {"22-10-2021 11:67:25", "%d-%M-%Y %H:%m:%S", :error},
  {"10/15/2022 09:12:11 +0700", "%M/%d/%Y %H:%m:%S %z", ~U[2022-10-15 02:12:11Z]},
  {"10/15/2022 09:12:11 -0230", "%M/%d/%Y %H:%m:%S %z", ~U[2022-10-15 11:42:11Z]},
]

{success, _error} =
Enum.reduce(cases, {0, 0}, fn {str, format, result}, {success, error} ->
  {status, dt} = DateTimeParser.parse(str, format)

  cond  do
    status == :error and result == :error ->
      {success + 1, error}
    status == :ok and result == dt ->
      {success + 1, error}
    true ->
      {success, error + 1}
  end
end)

IO.puts("Test passed: #{success}/#{length(cases)}")
=> Test passed: 10/10
```
