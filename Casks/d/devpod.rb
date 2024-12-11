cask "devpod" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.5"
  sha256 arm:   "eb03bd0c6246904e0d4e5bb4eff0f118760274bba92439034c02adb1ab818986",
         intel: "c75bfa59e11de2010f4e78a152ee6b32fad52703fe96ed143cb44c1198fe5322"

  url "https:github.comloft-shdevpodreleasesdownloadv#{version}DevPod_macos_#{arch}.dmg",
      verified: "github.comloft-shdevpod"
  name "DevPod"
  desc "UI to create reproducible developer environments based on a devcontainer.json"
  homepage "https:devpod.sh"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "DevPod.app"
  binary "#{appdir}DevPod.appContentsMacOSdevpod-cli", target: "devpod"

  zap trash: [
    "~.devpod",
    "~LibraryApplication Supportsh.loft.devpod",
    "~LibraryCachessh.loft.devpod",
    "~LibraryLogssh.loft.devpod",
    "~LibraryPreferencessh.loft.devpod.plist",
    "~LibrarySaved Application Statesh.loft.devpod.savedState",
    "~LibraryWebKitsh.loft.devpod",
  ]
end