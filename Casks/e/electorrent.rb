cask "electorrent" do
  version "2.8.3"
  sha256 "0069ff6fbed2870d33d6665f1f28d54b0b67036626368b94a0b7d3bdf82ccd8a"

  url "https:github.comtympanixElectorrentreleasesdownloadv#{version}electorrent-#{version}.dmg"
  name "Electorrent"
  desc "Desktop remote torrenting application"
  homepage "https:github.comtympanixElectorrent"

  livecheck do
    url "https:electorrent.vercel.appupdatedmg0.0.0"
    strategy :json do |json|
      json["name"]&.tr("v", "")
    end
  end

  auto_updates true

  app "Electorrent.app"

  zap trash: [
    "~LibraryApplication SupportElectorrent",
    "~LibraryPreferencescom.github.tympanix.Electorrent.plist",
    "~LibrarySaved Application Statecom.github.tympanix.Electorrent.savedState",
  ]

  caveats do
    requires_rosetta
  end
end