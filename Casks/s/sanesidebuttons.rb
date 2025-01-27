cask "sanesidebuttons" do
  version "1.4.1"
  sha256 "694a381e7dcef5a237e2eedb203c4fb63008faea7e3615c0070c437a53740403"

  url "https:github.comthealpaSaneSideButtonsreleasesdownload#{version}SaneSideButtons.dmg"
  name "SaneSideButtons"
  desc "Menu bar app that enables system-wide navigation using side mouse buttons"
  homepage "https:github.comthealpaSaneSideButtons"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sequoia"

  app "SaneSideButtons.app"

  zap trash: [
    "~LibraryApplication Scriptscom.janhuelsmann.SaneSideButtons",
    "~LibraryContainerscom.janhuelsmann.SaneSideButtons",
    "~LibraryPreferencescom.janhuelsmann.sanesidebuttons.plist",
  ]
end