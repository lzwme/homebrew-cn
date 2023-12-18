cask "qmk-toolbox" do
  version "0.2.2"
  sha256 "75f439a9d91630d2310968566bb703306ceba4797f9b5459b1269514be7a62d8"

  url "https:github.comqmkqmk_toolboxreleasesdownload#{version}QMK.Toolbox.app.zip",
      verified: "github.comqmkqmk_toolbox"
  name "QMK Toolbox"
  desc "Toolbox companion for QMK Firmware"
  homepage "https:qmk.fm"

  app "QMK Toolbox.app"

  uninstall quit: "fm.qmk.toolbox"

  zap trash: [
    "~LibraryCachesfm.qmk.toolbox",
    "~LibrarySaved Application Statefm.qmk.toolbox.savedState",
  ]
end