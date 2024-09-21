cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "32.1.2"
  sha256 arm:   "b5f6db900997ba931c98addaef28744a0a6af0f2ec2e8e5755f7f50db2fe8bbc",
         intel: "150ac6a59e31ad516685bdbb9cee67c7e927b872ad94ffc900fbf6616433f8ab"

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