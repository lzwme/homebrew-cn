cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "30.0.0"
  sha256 arm:   "4aa2411dbfeb5a0dc1b4582c27c3ad2983487fdfec30c10dfc9b6db54d31aba9",
         intel: "d6df477d98d0dc5ec33dc2df9a338347203edfb81f854a8ceb0ab05942885e69"

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