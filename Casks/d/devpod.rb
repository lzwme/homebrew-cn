cask "devpod" do
  arch arm: "aarch64", intel: "x64"

  version "0.5.20"
  sha256 arm:   "18f763c7abbcd83bda8c02868a6be6d4fb20e76b9dc7ca88665a278cf31a7c63",
         intel: "6ade3d4c58ce6c5b34820ebd70d6cb04830f7b328c73c9e1bed8f9b5a88a7420"

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