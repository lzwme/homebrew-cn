cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.85.0"
  sha256 arm:   "a276424ef686c0f14dfff2edfd7e142087e88dd7190789b4b20ac5a077d6b3b3",
         intel: "a6000cad57fd5397670b90058cdb250b97ffcf289a847f1f6beb0800baa0d283"

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