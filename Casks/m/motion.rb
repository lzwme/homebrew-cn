cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.93.0"
  sha256 arm:   "90942c4a6710afc46af13e306e9402b6462d76a9be22a9454c266fc0b4673390",
         intel: "7df8355990cf24d017ab241e471f52dbfde578fac2c5ac9685608c71b579ee21"

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