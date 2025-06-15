cask "sanesidebuttons" do
  on_sonoma :or_older do
    version "1.2.0"
    sha256 "c9bdf7cf464a7c68614c189a014fcb3bb2c92edcdc2826e33b983046e69ab742"

    livecheck do
      skip "Legacy version"
    end
  end
  on_sequoia :or_newer do
    version "1.4.1"
    sha256 "694a381e7dcef5a237e2eedb203c4fb63008faea7e3615c0070c437a53740403"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https:github.comthealpaSaneSideButtonsreleasesdownload#{version}SaneSideButtons.dmg",
      verified: "github.comthealpaSaneSideButtons"
  name "SaneSideButtons"
  desc "Menu bar app that enables system-wide navigation using side mouse buttons"
  homepage "https:janhuelsmann.comsanesidebuttons"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :ventura"

  app "SaneSideButtons.app"

  zap trash: [
    "~LibraryApplication Scriptscom.janhuelsmann.SaneSideButtons",
    "~LibraryContainerscom.janhuelsmann.SaneSideButtons",
    "~LibraryPreferencescom.janhuelsmann.sanesidebuttons.plist",
  ]
end