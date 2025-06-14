cask "brisk" do
  version "1.2.0"
  sha256 "1ad1da10a3bb2b31af88bc19b6f5b3a018de63e922f632fbdcd7a5e626b96601"

  url "https:github.combr1skbriskreleasesdownload#{version}Brisk.app.tar.gz"
  name "Brisk"
  desc "App for submitting radars"
  homepage "https:github.combr1skbrisk"

  livecheck do
    url "https:raw.githubusercontent.combr1skbriskmasterappcast.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "Brisk.app"

  zap trash: [
    "~LibraryApplication SupportBlisk",
    "~LibraryCachesBlisk",
    "~LibraryPreferencesorg.blisk.Blisk.plist",
    "~LibrarySaved Application Stateorg.blisk.Blisk.savedState",
  ]

  caveats do
    requires_rosetta
  end
end