cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "36.2.1"
  sha256 arm:   "118a340982393fc176ed94eee3b1ee9f3259679a7509351a413bfb14bb18931b",
         intel: "1d14342e70dd2bd3f49e93fd0ec00f128c68069de48b80e3ada407ef98ba8c0f"

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