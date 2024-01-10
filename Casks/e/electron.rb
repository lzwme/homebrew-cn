cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.1.2"
  sha256 arm:   "e39e436c199e46a7661e0b41ec17ed7670c04f7d9d4831a096873698f1231738",
         intel: "c38676995dfef20104983847a472fff53be8231241e9af6da89f6c2cbe5e5312"

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