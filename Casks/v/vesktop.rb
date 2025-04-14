cask "vesktop" do
  version "1.5.6"
  sha256 "4301bc07d9fe7ea34e44bc42cd4abefeb1d612a93436e22200b75570ea5b3af0"

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