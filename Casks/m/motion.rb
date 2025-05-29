cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.105.0"
  sha256 arm:   "cc0111b47d408f464266b2a102749b75e64939ea31cdfbd418d37f3cfb45dfec",
         intel: "9d41ec5fcf4472a2c8f0ba5881f3ba53bcb0e8c6b496bb300d8b44a007cdc084"

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