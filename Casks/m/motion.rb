cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.102.0"
  sha256 arm:   "fdde65d9eac6967ef2bb90f5a288a0febf74e5b5068a5005fe26706b22306788",
         intel: "ef5560af8575f41c25f595fe5e0e83e7667ff1a815dfa3d5710c816e9087b96f"

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