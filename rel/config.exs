use Mix.Releases.Config,
    default_release: :default,
    default_environment: :dev

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"v5fc=(EIW*7nk7/;&|9|M_<Zn7Xd^/<^%%KY~XgI_)tMrr!so@QJLV0T}cq0Y|wC"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set commands: [
    migrate: "rel/hooks/migrate.sh"
  ]
  set cookie: :"v5fc=(EIW*7nk7/;&|9|M_<Zn7Xd^/<^%%KY~XgI_)tMrr!so@QJLV0T}cq0Y|wC"
end

release :bird do
  set version: current_version(:bird)
end
