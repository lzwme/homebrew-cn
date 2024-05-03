cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "30.0.2"
  sha256 arm:   "c1f086f394c0241341c638e70ce2e486238905a82b6422f9236f12fb4d6be8cc",
         intel: "46379ec9aa24f4cd69e22b6d498455e0ee0b6d32c233028104833dfc35e52acf"

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