cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.83.0"
  sha256 arm:   "9fd94189624c6208f6d856440715ee04c0d4885953e1479723e1b5539c2736ec",
         intel: "e13c1567fa18dbdca191f50126208116cfd56702c61715ac7aefb7e8785289b7"

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