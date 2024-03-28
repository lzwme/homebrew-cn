cask "motion" do
  arch arm: "aarch64", intel: "amd64"

  version "0.67.0"
  sha256 arm:   "5948845ba942a104b8b120d3aed2dec9602810080ae7ac23b485b002e175d048",
         intel: "d824ee0ad9e9669886b4add8cfb8370bc8afafcd3fff33dd67d9dc96baad09e6"

  on_arm do
    depends_on macos: ">= :big_sur"
  end
  on_intel do
    depends_on macos: ">= :catalina"
  end

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

  app "Motion.app"

  zap trash: [
    "~LibraryApplication SupportMotion",
    "~LibraryHTTPStoragescom.electron.motion*",
    "~LibraryLogsMotion",
    "~LibraryPreferencescom.electron.motion.plist",
    "~LibrarySaved Application Statecom.electron.motion.savedState",
  ]
end