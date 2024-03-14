cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.1.3"
  sha256 arm:   "f95c0ebb13e55dccabba11b6289f0a5105264fa91c12c3001a7c996eef506fac",
         intel: "8fbc836465f0f66d84f8ffc7b2eb28a6f6d0734f59bc95a7e5e6f030c0f48ca1"

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