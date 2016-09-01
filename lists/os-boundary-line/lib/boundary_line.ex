
defmodule BoundaryLine do

  def trunc_to_fewer_dp string, dp do
    string |> String.replace(~r[(\d\.\d{#{dp}})\d+], "\\1")
  end

  def to_polygon wkt_polygon, dp do
    string = wkt_polygon
    |> String.split("((")
    |> List.last
    |> String.split("))")
    |> List.first

    if String.contains?(string, ")") do
      nil
    else
      {points, binding} = string
      |> String.replace( ~r{([^,]+)\s([^,]+)}, "[\\1,\\2]")
      |> String.replace(~r{^}, "[")
      |> String.replace(~r{$}, "]")
      |> Code.eval_string

      points
      |> Stream.map(& [&1 |> List.first |> Float.round(dp), &1 |> List.last |> Float.round(dp)] )
      |> Enum.dedup
    end
  end

  def stream(take \\ 1, file \\ 'county.csv', type \\ :county, dp \\ 1, filter \\ nil) do
    io = File.stream!(file)
    headers = io |> Enum.at(0)
    stream = io
    |> Stream.filter(& !String.contains?(&1, "WKT\tNAME"))

    stream = if filter do
               stream |> Stream.filter(& &1 |> String.match?(~r[#{filter}]))
             else
               stream
             end

    stream = if take do
               stream |> Stream.take(take)
             else
               stream
             end

    Stream.concat([headers], stream)
    |> Stream.map(& &1 |> trunc_to_fewer_dp(dp + 1))
    |> DataMorph.structs_from_tsv(:bl, type)
    |> Stream.map(& Map.put(&1, :wkt, BoundaryLine.to_polygon(&1.wkt, dp)) )
  end

  def tsv(take \\ 1, file \\ 'county.csv', type \\ :county, dp \\ 2, filter \\ nil) do
    tsv = stream(take, file, type, dp, filter)
    |> Stream.map(& [&1.code, &1.name, inspect(&1.wkt, limit: 100000) |> String.replace(", ",",") ])

    Stream.concat([~W[os-boundary-line name polyline]], tsv)
    |> CSV.encode(separator: ?\t, delimiter: "\n")
    |> Enum.each(& IO.puts &1 |> String.replace("\n", ""))
  end

end
