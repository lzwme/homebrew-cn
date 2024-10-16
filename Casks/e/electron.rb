cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "33.0.0"
  sha256 arm:   "75f3267e5517bb35cbfc11f2d5673947cfa8a510dc3a78c46356a948650027f2",
         intel: "945a07cec9eb2bdfa6a7ae6971f1df564447a5eeea3d533abae3ef5eac1966a1"

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