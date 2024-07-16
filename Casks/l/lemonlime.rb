cask "lemonlime" do
  arch arm: "arm64", intel: "x86_64"

  version "0.3.5"
  sha256 arm:   "ba44fd655b53a2827034e2ddefb60648adbe0cfe390a8163552140e74a2656b5",
         intel: "500103bc88198b7ad875069d8030d30c5c677cd773196c237f2dc068cc6db038"

  url "https:github.comProject-LemonLimeProject_LemonLimereleasesdownload#{version}lemon-Qt6.7.2-Release-#{arch}.dmg"
  name "lemonlime"
  desc "Tiny judging environment for OI contest based on Lemon + LemonPlus"
  homepage "https:github.comProject-LemonLimeProject_LemonLime"

  app "lemon.app"

  zap trash: [
    "~DocumentsProject_LemonLime",
    "~LibraryPreferencescom.github.lemonlime.plist",
    "~LibraryPreferencescom.lemonlime.lemon.plist",
    "~LibrarySaved Application Statecom.github.lemonlime.savedState",
  ]
end