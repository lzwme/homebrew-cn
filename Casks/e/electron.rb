cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.1.1"
  sha256 arm:   "b0d569e3299aa253e3a02603509e9c9c501ffe86dc66c0ce9260448c1a59080f",
         intel: "50da9e5aea41a13d589ad61d84ae71046410dfa7e46860f25b6af39f818752e5"

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