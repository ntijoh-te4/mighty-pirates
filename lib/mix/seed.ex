defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS students", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE fruits (id SERIAL, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)

    Postgrex.query!(DB, "Create TABLE students (
      id SERIAL NOT NULL UNIQUE ,
      f_name	TEXT NOT NULL,
      l_name	TEXT NOT NULL,
      img	TEXT,
      PRIMARY KEY(id)
    )", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")

    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple",6], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["banna",2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["pear",4], pool: DBConnection.ConnectionPool)


    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Ryan","Reynolds","ryan.jpeg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Brad","Pitt","brad.jpg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Eddie","Meduza","eddie.jpeg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Tom","Holland","tom.jpeg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Gustav","Fridolin","gurra.jpeg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Johnny","Depp","johnny.jpg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Hakan","Hellstrom","hakan.jpeg"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO students(f_name, l_name, img) VALUES($1, $2, $3)", ["Henry","Cavill","superman.jpeg"], pool: DBConnection.ConnectionPool)
  end

end
