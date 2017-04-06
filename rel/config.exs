use Mix.Releases.Config,
    default_release: :default,
    default_environment: :dev

environment :dev do
  set dev_mode: true
  set include_erts: false
end

environment :prod do
  set include_erts: true
  set include_src: false
  set pre_start_hook: "rel/hooks/migrate.sh"
end

release :bird do
  set version: current_version(:bird)
end
