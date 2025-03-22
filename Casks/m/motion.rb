cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.95.0"
  sha256 arm:   "eaf86098a64c910d0ea333f965352828ae3b8923d433d7e8c3e94672af025bfe",
         intel: "9a8b97fe8b8a7111bb9272a813e54ffd6fcb5595a620f1edeb3f62cf85066aa9"

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