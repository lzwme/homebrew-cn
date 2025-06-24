cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.108.0"
  sha256 arm:   "1c5c4e830671522445ae8052eb411e8115145b1716bb4f19a7fb0b70988fd85b",
         intel: "bda135a09c5d44387abaf08e8a154a0324c428c24567408ac7e81785605cd8b9"

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