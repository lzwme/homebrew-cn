cask "alcove" do
  version "1.2.1"
  sha256 "21b1a5e877f31fa3c761834bf7674dd4c2d797555fa99e41284384d68006290b"

  url "https:github.comhenrikrusconalcove-releasesreleasesdownload#{version}Alcove.zip",
      verified: "github.comhenrikrusconalcove-releases"
  name "Alcove"
  desc "Utility to add Dynamic Island like features to notch area"
  homepage "https:tryalcove.com"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Alcove.app"

  zap trash: [
    "~LibraryCachescom.henrikruscon.Alcove",
    "~LibraryHTTPStoragescom.henrikruscon.Alcove",
    "~LibraryPreferencescom.henrikruscon.Alcove.plist",
  ]
end