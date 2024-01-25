cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.2.0"
  sha256 arm:   "483fa11d1e6abb0cb3955b3f4ae4e7ca49617ea4fdc49d192ee5d642b08ea711",
         intel: "b415ec0987c622ce4f6890e0babe88e0f9cb6b4716bfe8aa79b70f475d8bcafa"

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