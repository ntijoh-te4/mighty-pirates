defmodule Pluggy.GameController do
  require IEx

  alias Pluggy.Game
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do
    #srender använder slime
    randomnumer = Enum.random(0..7)
    send_resp(conn, 200, render("students/game", students: Game.get("#{randomnumer}") ))
  end

end
