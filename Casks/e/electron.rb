cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "36.1.0"
  sha256 arm:   "5f38c1939c76a6299ac68a9b5b56deea8d81f4ac02f5855a59a7aad4c3c86eef",
         intel: "86eb97a6b4f800efc82910cf366e1e1c93fbc003dcb55aad5f78a0af4f0b826e"

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