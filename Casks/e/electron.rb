cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "37.2.0"
  sha256 arm:   "4e43432b53a118635048408851130a7065b3cfb193382c0cd755c9f56b2dbf06",
         intel: "e2d50fb9c6a7ea2a964ddc8fd925cbf9526048d890256983a66ea0a897c94196"

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