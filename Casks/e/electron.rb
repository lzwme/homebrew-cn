cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.2.3"
  sha256 arm:   "5a21e461fcccd161bd4e78b8d8af437a488ee276170919b8e0f551fed1ae3619",
         intel: "3ee7cb9eb3d4e601feb40874b37ec0d1ea4c9f249ee1f1be6124602ab0db56e0"

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