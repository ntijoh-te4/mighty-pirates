defmodule Pluggy.Template do
  def srender(file, data \\ [], layout \\ true) do
    {:ok, template} = File.read("templates/#{file}.slime")

    case layout do
      true ->
        {:ok, layout} = File.read("templates/layout.slime")
        Slime.render(layout, template: Slime.render(template, data))

      false ->
        Slime.render(template, data)
    end
  end

  def render(file, data \\ [], layout \\ true)
  def render(file, data, layout) do
    case layout do
      true ->
        rendered_template = EEx.eval_file("templates/#{file}.eex", data)
        EEx.eval_file("templates/layout.eex", template: rendered_template, data: data )

      false ->
        EEx.eval_file("templates/#{file}.eex", data)
    end
  end
end
