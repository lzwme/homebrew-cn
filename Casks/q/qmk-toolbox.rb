cask "qmk-toolbox" do
  version "0.3.3"
  sha256 "58faded9cb06010cdabed92c2db8f72ff32b5944fa776813255abb7809a970b9"

  url "https:github.comqmkqmk_toolboxreleasesdownload#{version}QMK.Toolbox.app.zip",
      verified: "github.comqmkqmk_toolbox"
  name "QMK Toolbox"
  desc "Toolbox companion for QMK Firmware"
  homepage "https:qmk.fm"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :monterey"

  app "QMK Toolbox.app"

  uninstall quit: "fm.qmk.toolbox"

  zap trash: [
    "~LibraryCachesfm.qmk.toolbox",
    "~LibrarySaved Application Statefm.qmk.toolbox.savedState",
  ]
end