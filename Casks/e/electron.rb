cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "36.5.0"
  sha256 arm:   "d416d9ed16e4739a73c61260db5dc7f6e42d32f4cb849e4a4f9bfdd5f5b430fa",
         intel: "d8a283648c39abe0ada9e697502c29a61463ce2f1ca7d83a8fb684cf9f7a9190"

  url "https:github.comelectronelectronreleasesdownloadv#{version}electron-v#{version}-darwin-#{arch}.zip",
      verified: "github.comelectronelectron"
  name "Electron"
  desc "Build desktop apps with JavaScript, HTML, and CSS"
  homepage "https:electronjs.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Electron.app"
  binary "#{appdir}Electron.appContentsMacOSElectron", target: "electron"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.electron.sfl*",
    "~LibraryApplication SupportElectron",
    "~LibraryCachesElectron",
    "~LibraryPreferencescom.github.electron.helper.plist",
    "~LibraryPreferencescom.github.electron.plist",
    "~LibrarySaved Application Statecom.github.Electron.savedState",
  ]
end