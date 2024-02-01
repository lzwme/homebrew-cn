cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.2.1"
  sha256 arm:   "8193e939b8f8d942dcc0271f4bb029869aa4576b7406e4591f11a4657ae53c0e",
         intel: "07ae2241f00aafa5e204628668f581046668b22e955146dd02c0fa8698f4b2e3"

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