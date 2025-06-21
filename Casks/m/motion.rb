cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.107.0"
  sha256 arm:   "693ca5784e767b38e3bd8afd363224eea37060e1137d31247da593e19bbdb429",
         intel: "f05a157c5b8c08ef696f8944c858bda549d5d9b36d5456dd77969f66b06a66df"

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