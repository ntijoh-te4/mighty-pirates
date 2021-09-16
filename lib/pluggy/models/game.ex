defmodule Pluggy.Game do
  defstruct(id: nil, f_name: "", l_name: "", img: "")

  alias Pluggy.Game

  def all do
    Postgrex.query!(DB, "SELECT * FROM students", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end
  def get_random do
    Postgrex.query!(DB, "SELECT * FROM students ORDER BY RANDOM() LIMIT 5", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end


  def to_struct([[id, f_name, l_name, img]]) do
    %Game{id: id, f_name: f_name, l_name: l_name, img: img}
  end

  def to_struct_list(rows) do
    for [id, f_name, l_name, img] <- rows, do:  %Game{id: id, f_name: f_name, l_name: l_name, img: img}
  end
end
