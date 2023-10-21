[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  import_deps: [:phoenix, :phoenix_live_view],
  subdirectories: ["priv/*/migrations"],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
