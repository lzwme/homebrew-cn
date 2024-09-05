cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "32.0.2"
  sha256 arm:   "de8b3c3e5278d45aa8fea9e9c261ce5c6daa3d0f569376014896fd03ba844b5f",
         intel: "a9a8b30a1847236dca495041644cea27a08823bf6a5d314bd21a8fbe92b91d67"

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