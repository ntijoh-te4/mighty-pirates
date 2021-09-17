defmodule Pluggy.GameController do
  require IEx

  alias Pluggy.Game
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    #srender använder slime
    students = Game.get_random()
    all_students = Game.all()
    all_student = length(all_students)
    # IO.puts("---------------------------")
    # IO.inspect(students)
    # IO.puts("---------------------------")
    #IO.inspect(all_student)
    correct_student = Enum.random(students)
    counter = conn.private.plug_session["counter"]

    if counter >= all_student do
      Plug.Conn.put_session(conn, :students, nil)
    |> Plug.Conn.put_session(:correct_student, nil)
    |> Plug.Conn.put_session(:fullname, nil)
    |> Plug.Conn.put_session(:counter, 0)
    |> Plug.Conn.put_session(:guess_name, nil)
    |> Plug.Conn.put_session(:all_student, nil)
    |> redirect("/game/done")
    else
      Plug.Conn.put_session(conn, :students, students)
    |> Plug.Conn.put_session(:correct_student, correct_student)
    |> Plug.Conn.put_session(:fullname, nil)
    |> Plug.Conn.put_session(:counter, counter)
    |> Plug.Conn.put_session(:all_student, all_student)
    |> Plug.Conn.put_session(:guess_name, nil)
    |> redirect("/game/run")
    end


    #TODO: Om correct_student finns i listan gör index(conn)
    #Annars, fortsätt


  end

  def run(conn) do
    correct_student = conn.private.plug_session["correct_student"]
    students = conn.private.plug_session["students"]
    guess_name = conn.private.plug_session["guess_name"]
    full_name = conn.private.plug_session["fullname"]
    counter = conn.private.plug_session["counter"]
    all_student = conn.private.plug_session["all_student"]
    # IO.puts("---------------------------")
    # IO.inspect(students)
    # IO.puts("---------------------------")

    send_resp(conn, 200, render("students/game",
    correct_student: correct_student, students: students, guess_name: guess_name, full_name: full_name, counter: counter , all_student: all_student))

  end

  def validate_answer(conn, params) do
    guess_name = params["guess_name"]
    correct_student = conn.private.plug_session["correct_student"]
    #IO.inspect(correct_student)
    #IO.inspect(guess_name)
    fullname = "#{correct_student.f_name} #{correct_student.l_name}"
    #IO.inspect(fullname)

    if fullname == guess_name do
      IO.puts "correct"
      counter = conn.private.plug_session["counter"]
      Plug.Conn.put_session(conn, :fullname, fullname)
      |> Plug.Conn.put_session(:counter, counter + 1)
      |> Plug.Conn.put_session(:guess_name, guess_name)
      |> redirect( "/game/run")
    else
      IO.puts "Wrong"
      counter = conn.private.plug_session["counter"]
      Plug.Conn.put_session(conn, :fullname, fullname)
      |> Plug.Conn.put_session(:counter, counter)
      |> Plug.Conn.put_session(:guess_name, guess_name)
      |> redirect( "/game/run")
    end





  end


  def done(conn) do
    send_resp(conn, 200, render("students/done",[]))
  end
  #Om knappen är lika med correct_student
    #plussa på acc
    #lägg till correct_student i listan
    #sätt färgen till grön
  #Annars
    #sätt färgen till röd

  defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")


end
