cask "legcord" do
  version "1.0.8"
  sha256 "b2aacc01d4f5c7eeee244aef871bbebedc881b4c28304edcec476f74312abb0f"

  url "https:github.comlegcordlegcordreleasesdownloadv#{version}legcord-#{version}-mac-universal.dmg",
      verified: "github.comlegcordlegcord"
  name "Legcord"
  desc "Custom Discord client"
  homepage "https:legcord.app"

  livecheck do
    url "https:legcord.applatest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: ">= :big_sur"

  app "legcord.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.legcord.legcord.sfl*",
    "~LibraryApplication Supportlegcord",
    "~LibraryPreferencesapp.legcord.Legcord.plist",
    "~LibrarySaved Application Stateapp.legcord.Legcord.savedState",
  ]
end