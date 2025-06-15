cask "sqlectron" do
  version "1.38.0"
  sha256 "30c338d72d0262b4f40d9e105f4e1e0972c24103f7c3b695fdd5cb42a3ada84e"

  url "https:github.comsqlectronsqlectron-guireleasesdownloadv#{version}Sqlectron-#{version}-mac.zip",
      verified: "github.comsqlectronsqlectron-gui"
  name "Sqlectron"
  homepage "https:sqlectron.github.io"

  no_autobump! because: :requires_manual_review

  app "sqlectron.app"

  zap trash: [
    "~.sqlectron.json",
    "~LibraryApplication SupportSqlectron",
  ]

  caveats do
    requires_rosetta
  end
end