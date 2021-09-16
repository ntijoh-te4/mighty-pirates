defmodule Pluggy.GameController do
  require IEx

  alias Pluggy.Game
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    #srender använder slime
    students = Game.get_random()
    # IO.puts("---------------------------")
    # IO.inspect(students)
    # IO.puts("---------------------------")
    correct_student = Enum.random(students)
    Plug.Conn.put_session(conn, :students, students)
    |> Plug.Conn.put_session(:correct_student, correct_student ) |> redirect("/game/run")
    #TODO: Om correct_student finns i listan gör index(conn)
    #Annars, fortsätt


  end

  def run(conn) do
    correct_student = conn.private.plug_session["correct_student"]
    students = conn.private.plug_session["students"]
    # IO.puts("---------------------------")
    # IO.inspect(students)
    # IO.puts("---------------------------")

    send_resp(conn, 200, render("students/game", correct_student: correct_student, students: students))

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
      
      redirect(conn, "/game/run")
    else
      IO.puts "Wrong"
      redirect(conn, "/game/run")
    end



  end
  #Om knappen är lika med correct_student
    #plussa på acc
    #lägg till correct_student i listan
    #sätt färgen till grön
  #Annars
    #sätt färgen till röd

  defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")


end
