cask "manuskript" do
  version "0.16.1"
  sha256 "f67f3f44fee26259c04eb2df24b7a85b71c9963be1fe93d5c24e738af4a2d2af"

  url "https:github.comolivierkesmanuskriptreleasesdownload#{version.major_minor_patch}manuskript-#{version}-osx.dmg",
      verified: "github.comolivierkesmanuskript"
  name "Manuskript"
  desc "Tool for writers"
  homepage "https:www.theologeek.chmanuskript"

  livecheck do
    url "https:www.theologeek.chmanuskriptdownload"
    regex(href.*?manuskript[._-]v?(\d+(?:\.\d+)+)[._-]osx\.dmgi)
  end

  no_autobump! because: :requires_manual_review

  app "manuskript.app"

  zap trash: [
    "~LibraryApplication Supportmanuskript",
    "~LibraryPreferencesch.theologeek.www.manuskript.plist",
    "~LibraryPreferencescom.manuskript.manuskript.plist",
    "~LibrarySaved Application Statech.theologeek.manuskript.savedState",
  ]

  caveats do
    requires_rosetta
  end
end