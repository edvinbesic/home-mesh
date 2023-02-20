#
#  Home Mesh: Firmware
#  ---
#  The firmware project is a poncho project where we conditionally pull in the
#  applications we wish to run based on the HM_NODE_TYPE environmental variable.
#  This allows us to manage the nerves/hardware integration in one project and
#  keep our business logic separate but composable.
#
#  For example, to compile our collector node for rpi0:
#
#    HM_NODE_TYPE=collector MIX_TARGET=rpi0 mix firmware
#
defmodule HmFirmware.MixProject do
  use Mix.Project

  @app :hm_firmware
  @version "0.1.0"
  @all_targets [
    :rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :osd32mp1, :x86_64, :grisp2
  ]
  @node_type String.to_atom(System.get_env("HM_NODE_TYPE"))

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.11"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {HmFirmware.Application, []},
      extra_applications: [:logger, :runtime_tools] ++ extra_apps(@node_type)
    ]
  end

  def extra_apps(:gateway) do
    [:hm_gateway]
  end

  def extra_apps(:collector) do
    [:hm_collector]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.7.16 or ~> 1.8.0 or ~> 1.9.0", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.8.5"},
      {:toolshed, "~> 0.2.26"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.13.0", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      {:nerves_system_rpi, "~> 1.19", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.19", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.19", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 1.19", runtime: false, targets: :rpi3},
      {:nerves_system_rpi3a, "~> 1.19", runtime: false, targets: :rpi3a},
      {:nerves_system_rpi4, "~> 1.19", runtime: false, targets: :rpi4},
      {:nerves_system_bbb, "~> 2.14", runtime: false, targets: :bbb},
      {:nerves_system_osd32mp1, "~> 0.10", runtime: false, targets: :osd32mp1},
      {:nerves_system_x86_64, "~> 1.19", runtime: false, targets: :x86_64},
      {:nerves_system_grisp2, "~> 0.3", runtime: false, targets: :grisp2}
    ] ++ deps(@node_type)
  end

  defp deps(:gateway) do
    [
      {:hm_gateway, path: "../../modules/gateway", targets: @all_targets}
    ]
  end

  defp deps(:collector) do
    [
      {:hm_collector, path: "../../modules/collector", targets: @all_targets}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
