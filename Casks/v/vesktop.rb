cask "vesktop" do
  version "1.5.5"
  sha256 "9644e6e5d59b28ff34c3a25b9c5c24d3510cdf0de0bbe1ef2c0bff0e07ca64d2"

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