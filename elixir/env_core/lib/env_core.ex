defmodule EnvCore do
  @moduledoc """
  Documentation for EnvCore.
  """

  def announce_run(command, announce, opts \\ []) do
    %{ important: important } = Enum.into(opts, %{important: nil})
    IO.puts "------------------------------------------------------\n"
    if important do
      IO.puts IO.ANSI.red_background() <> IO.ANSI.white() <> announce <> IO.ANSI.reset
      IO.puts "Command: #{command}"
    else
      IO.puts command
    end
    command
    |> String.to_char_list
    |> :os.cmd
    |> IO.puts
    IO.puts "------------------------------------------------------\n"
  end

  @doc """
  Uninstall rust
  """
  def uninstall_rust do
    announce_run("rustup self uninstall -y", "Uninstalling rust", important: true)
  end

  def install_rust do
    announce_run("curl https://sh.rustup.rs -sSf | sh -s -- -y", "Installing rust")
  end

  def update_rust do
    announce_run("rustup update", "Updating rust");
  end

  def redo_rust do
    uninstall_rust
    install_rust
    update_rust
  end
end
