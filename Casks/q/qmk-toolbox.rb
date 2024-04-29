cask "qmk-toolbox" do
  version "0.3.2"
  sha256 "9ccf2d361f26f129b1c6df7ea6d10c3ddf8142dbeb96f4bebb267bf12a76f930"

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