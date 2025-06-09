cask "vesktop" do
  version "1.5.7"
  sha256 "ef697fcf2ca40914b784eca700af3f5a41467f4eccd8680d3055ac6add94fdd7"

  url "https:github.comVencordVesktopreleasesdownloadv#{version}Vesktop-#{version}-universal.dmg"
  name "Vesktop"
  desc "Custom Discord App"
  homepage "https:github.comVencordVesktop"

  livecheck do
    url "https:github.comVencordVesktopreleaseslatestdownloadlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Vesktop.app"

  zap trash: [
    "~LibraryApplication Supportvesktop",
    "~LibraryCachesdev.vencord.vesktop",
    "~LibraryCachesdev.vencord.vesktop.Shipit",
    "~LibraryHTTPStoragesdev.vencord.vesktop",
    "~LibraryPreferencesdev.vencord.vesktop.plist",
    "~LibrarySaved Application Statedev.vencord.vesktop.savedState",
  ]
end