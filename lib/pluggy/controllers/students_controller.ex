defmodule Pluggy.StudentController do
  require IEx

  alias Pluggy.Students
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]
    username = "user"

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    #srender använder slime
    send_resp(conn, 200, render("students/index", students: Students.all(), username: username ))
  end

end
