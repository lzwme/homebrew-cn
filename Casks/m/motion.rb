cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.101.0"
  sha256 arm:   "e6618c4c248a2c5ca8a4991c58e0bd445924d4a0b822d22e997f1e6b3953bd1c",
         intel: "192841ddf130b05da4cf727bc7e1e5dbff049985aef68a086c6513fd9b8b2e50"

  url "https:github.comusemotiondesktopappreleasesdownload#{version}motion-#{version}-mac-#{arch}.zip",
      verified: "github.comusemotiondesktopapp"
  name "Motion"
  desc "To-do list and project management app"
  homepage "https:www.usemotion.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Motion.app"

  zap trash: [
    "~LibraryApplication SupportMotion",
    "~LibraryHTTPStoragescom.electron.motion*",
    "~LibraryLogsMotion",
    "~LibraryPreferencescom.electron.motion.plist",
    "~LibrarySaved Application Statecom.electron.motion.savedState",
  ]
end