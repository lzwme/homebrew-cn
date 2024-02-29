cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.1.0"
  sha256 arm:   "9a04b5aba3c4b9817259a0df1a622dcf792d0dbed9dbfe3f2614b992857140c3",
         intel: "2e8481d4a2c286e01b33623f0d2e9497d505f097393774cbb0b009c7a6d718b7"

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