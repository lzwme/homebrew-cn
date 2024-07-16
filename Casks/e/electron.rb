cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "31.2.1"
  sha256 arm:   "2709a669409bfbf32a3c232a846b2e37a0978d93cce005879a4267d5b48f1fe2",
         intel: "6eda8664ea6c70f08f223097576db9b9fd66beabb77c74cf61c4a4145da6ac98"

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