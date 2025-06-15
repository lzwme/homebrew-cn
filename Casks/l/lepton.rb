cask "lepton" do
  version "1.10.0"
  sha256 "060071b6b2c3e52e0be04e6f118d77fbcc7afdae50895545bfda0b04b9cc1c12"

  url "https:github.comhackjutsuLeptonreleasesdownloadv#{version}Lepton-#{version}.dmg",
      verified: "github.comhackjutsuLepton"
  name "Lepton"
  desc "Snippet management app"
  homepage "https:hackjutsu.comLepton"

  no_autobump! because: :requires_manual_review

  app "Lepton.app"

  zap trash: [
    "~LibraryApplication SupportLepton",
    "~LibraryPreferencescom.cosmox.lepton.helper.plist",
    "~LibraryPreferencescom.cosmox.lepton.plist",
    "~LibrarySaved Application Statecom.cosmox.lepton.savedState",
  ]

  caveats do
    requires_rosetta
  end
end