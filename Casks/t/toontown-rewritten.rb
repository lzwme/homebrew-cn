cask "toontown-rewritten" do
  version "1.5.1"
  sha256 "c88cd534c903ffc0a5e8696de4f18455e1193b18afa607db54689283c951b4df"

  url "https:download.toontownrewritten.comlaunchermacupdates#{version}ttr_launcher_#{version}.zip"
  name "Toontown Rewritten"
  name "Toontown Launcher"
  desc "Fan-made revival of Disney's Toontown Online"
  homepage "https:www.toontownrewritten.com"

  livecheck do
    url "https:download.toontownrewritten.comlaunchermacToontown%20Rewritten.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  # Renamed for consistency: app name is different in the Finder and in a shell.
  # Original discussion: https:github.comHomebrewhomebrew-caskpull8037
  app "Toontown Launcher.app", target: "Toontown Rewritten.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.toontownrewritten.toontown-launcher.sfl*",
    "~LibraryCachescom.toontownrewritten.Toontown-Launcher",
    "~LibraryHTTPStoragescom.toontownrewritten.Toontown-Launcher",
    "~LibraryPreferencescom.toontownrewritten.Toontown-Launcher.plist",
    "~LibrarySaved Application Statecom.toontownrewritten.Toontown-Launcher.savedState",
  ]
end