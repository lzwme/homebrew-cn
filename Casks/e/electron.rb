cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.2.0"
  sha256 arm:   "3ff37e2eb71abc187ed0f55570f141326a126a4faed1bd04efbb2ff3f4cf2582",
         intel: "17b37f38369458e5b558d38b66658e6295ab5975ab87b46720c6bed94ce9e07b"

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