cask "qmk-toolbox" do
  version "0.3.0"
  sha256 "2ab5e8914ae09571387a67ddc4032ec7ae0220774e9bde865fbdb3ad75f1c5a5"

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