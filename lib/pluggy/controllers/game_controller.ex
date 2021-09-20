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
    student_ammount = length(all_students)
    # IO.puts("---------------------------")
    # IO.inspect(students)
    # IO.puts("---------------------------")
    #IO.inspect(student_ammount)
    correct_student = Enum.random(students)
    counter = conn.private.plug_session["counter"]

    if counter >= student_ammount do
      Plug.Conn.put_session(conn, :students, nil)
      |> Plug.Conn.put_session(:correct_student, nil)
      |> Plug.Conn.put_session(:correct_student_name, nil)
      |> Plug.Conn.put_session(:counter, 0)
      |> Plug.Conn.put_session(:name_guessed, nil)
      |> Plug.Conn.put_session(:student_ammount, nil)
      |> redirect("/game/done")
    else
      Plug.Conn.put_session(conn, :students, students)
      |> Plug.Conn.put_session(:correct_student, correct_student)
      |> Plug.Conn.put_session(:correct_student_name, nil)
      |> Plug.Conn.put_session(:counter, counter)
      |> Plug.Conn.put_session(:student_ammount, student_ammount)
      |> Plug.Conn.put_session(:name_guessed, nil)
      |> redirect("/game/run")
    end

    #TODO: Om correct_student finns i listan gör index(conn)
    #Annars, fortsätt

  end

  def run(conn) do
    correct_student = conn.private.plug_session["correct_student"]
    students = conn.private.plug_session["students"]
    name_guessed = conn.private.plug_session["name_guessed"]
    correct_student_name = conn.private.plug_session["correct_student_name"]
    counter = conn.private.plug_session["counter"]
    student_ammount = conn.private.plug_session["student_ammount"]
    # IO.puts("---------------------------")
    # IO.inspect(students)
    # IO.puts("---------------------------")

    send_resp(conn, 200, render("students/game",
    correct_student: correct_student, students: students, name_guessed: name_guessed, correct_student_name: correct_student_name, counter: counter , student_ammount: student_ammount))
  end

  def validate_answer(conn, params) do
    name_guessed = params["name_guessed"]
    correct_student = conn.private.plug_session["correct_student"]
    #IO.inspect(correct_student)
    #IO.inspect(name_guessed)
    correct_student_name = "#{correct_student.f_name} #{correct_student.l_name}"
    #IO.inspect(correct_student_name)

    if correct_student_name == name_guessed do
      IO.puts "correct"
      counter = conn.private.plug_session["counter"]
      Plug.Conn.put_session(conn, :correct_student_name, correct_student_name)
      |> Plug.Conn.put_session(:counter, counter + 1)
      |> Plug.Conn.put_session(:name_guessed, name_guessed)
      |> redirect( "/game/run")
    else
      IO.puts "Wrong"
      counter = conn.private.plug_session["counter"]
      Plug.Conn.put_session(conn, :correct_student_name, correct_student_name)
      |> Plug.Conn.put_session(:counter, counter)
      |> Plug.Conn.put_session(:name_guessed, name_guessed)
      |> redirect( "/game/run")
    end
  end

  def done(conn) do
    send_resp(conn, 200, render("students/done",[]))
  end

  defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

end
