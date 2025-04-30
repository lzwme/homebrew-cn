cask "outerbase-studio" do
  version "0.1.29"
  sha256 "0d1345573e15296285f8fb3fb0c8bb3b617afe55e2beaef73c87f1f338f976a3"

  url "https:github.comouterbasestudio-desktopreleasesdownloadv#{version}outerbase-mac-#{version}.dmg"
  name "Outerbase Studio Desktop"
  desc "Database GUI"
  homepage "https:github.comouterbasestudio-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Outerbase Studio.app"

  zap trash: [
    "~LibraryApplication Supportouterbase-studio-desktop",
    "~LibraryLogsouterbase-studio-desktop",
    "~LibraryPreferencescom.outerbase.studio.plist",
  ]
end