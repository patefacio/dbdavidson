defmodule EnvCore do
  @moduledoc """
  Documentation for EnvCore.
  """

  def announce_run(command, announce \\ nil, opts \\ []) do
    %{ important: important } = Enum.into(opts, %{important: nil})
    IO.puts "------------------------------------------------------\n"
    if important do
      if announce do
        IO.puts IO.ANSI.red_background() <> IO.ANSI.white() <> announce <> IO.ANSI.reset
      end
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
  def uninstall_rust() do
    announce_run("rustup self uninstall -y", "Uninstalling rust", important: true)
  end

  def install_rust() do
    announce_run("curl https://sh.rustup.rs -sSf | sh -s -- -y", "Installing rust")
  end

  def update_rust() do
    announce_run("rustup update", "Updating rust")
  end

  def install_nightly() do
    announce_run("rustup install nightly")
  end

  @doc "Install rustfmt

  rustfmt and clippy are kind of a mess. Apparantly the bulk of work
  is done in nightly and trying to get into stable is not really
  there. So you either have to:

  `rustup component add rustfmt --toolchain nightly`

  to attempt to install for nightly and take the risk of it not being
  there. For some reason it is not in all releases. Alternatively, do
  what is done below - add the preview version and use from stable.

  Once this is done you should be able to do `cargo-fmt`. Similar for
  `cargo-clippy`

  "
  def install_fmt() do
    announce_run("rustup component add rustfmt-preview")
  end

  def install_clippy() do
    announce_run("rustup component add clippy-preview")
  end


  def redo_rust() do
    uninstall_rust
    install_rust
    update_rust
    install_fmt
    install_clippy
  end
end
