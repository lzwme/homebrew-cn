cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.1.6"
  sha256 arm:   "02eaa03acde8dad8a227a08ef48c77e19fe29cfa945de3d986519420dddcf4c3",
         intel: "b17e76aa5598027bde3b9e178e265137d16f6cea2ac7f3c3fc635addde4fbd15"

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