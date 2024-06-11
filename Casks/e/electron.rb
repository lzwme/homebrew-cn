cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "31.0.0"
  sha256 arm:   "f1ebb3e17ecb10ab860566b496949c206624b44affffdfd99640ea0f6eb51af0",
         intel: "87a274b1f84d7399fbe8c9160612c51a72e0d9b48f51d09e8c05e45e98b0e3dd"

  url "https:github.comelectronelectronreleasesdownloadv#{version}electron-v#{version}-darwin-#{arch}.zip",
      verified: "github.comelectronelectron"
  name "Electron"
  desc "Build desktop apps with JavaScript, HTML, and CSS"
  homepage "https:electronjs.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Electron.app"
  binary "#{appdir}Electron.appContentsMacOSElectron", target: "electron"

  zap trash: [
    "~LibraryApplication SupportElectron",
    "~LibraryCachesElectron",
    "~LibraryPreferencescom.github.electron.helper.plist",
    "~LibraryPreferencescom.github.electron.plist",
  ]
end