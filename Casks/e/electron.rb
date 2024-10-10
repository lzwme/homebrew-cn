cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "32.2.0"
  sha256 arm:   "f33db0420ae1b306ab927ade884d5f5968603c853dec14cfa25b145e9aef52ad",
         intel: "4abdc2ebc1f9665070849818ba1dba19b72c6c20339c6a7855fb8c7919cce903"

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