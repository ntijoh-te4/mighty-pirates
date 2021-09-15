defmodule Pluggy.Students do
  defstruct(id: nil, f_name: "", l_name: "", img: "")

  alias Pluggy.Students

  def all do
    Postgrex.query!(DB, "SELECT * FROM students", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def to_struct([[id, f_name, l_name, img]]) do
    %Students{id: id, f_name: f_name, l_name: l_name, img: img}
  end

  def to_struct_list(rows) do
    for [id, f_name, l_name, img] <- rows, do:  %Students{id: id, f_name: f_name, l_name: l_name, img: img}
  end
end
