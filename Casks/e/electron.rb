cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "33.3.0"
  sha256 arm:   "c534ef4b8e7859620e7944b42a460b3fd2e27db1512b3820150b73c7df81b63d",
         intel: "de05d4004facdb4693f5b8ecad7d1b1bb162919edf59b4c1ce9f5ee3906e1742"

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