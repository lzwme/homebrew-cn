cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "31.2.0"
  sha256 arm:   "278d554194babe49b2583052c957d1b87657f709d7f3907227e87c25a7c6077b",
         intel: "f3a999776c1d63ebc57169b5341bb1452118eb1e1775946450be5a48d21ab10e"

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