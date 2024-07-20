cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.82.0"
  sha256 arm:   "2ec28a0330930ab4ac95e53174394b006727d7d13eb2ecee16f37618ec0469fa",
         intel: "f94a570e08b67bfeb8dae50ea1a30e12bca2e2425e0dbf3fdd1ff2e88a1f1f13"

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