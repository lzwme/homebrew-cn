cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.97.0"
  sha256 arm:   "812c5584599a3646ff4c180aa08c63e70cbef1e0d823dbfb6929b950fbde8ba7",
         intel: "4dcd9de247ee8c94e7a556c06f64ce57a114e7411cb454b6b108497ff9839c3d"

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