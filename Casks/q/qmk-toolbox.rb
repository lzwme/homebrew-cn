cask "qmk-toolbox" do
  version "0.3.1"
  sha256 "277ca1fd5b13480c94ebcf3f193a0e23884e91115da33c5356fa7d629fdb2258"

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