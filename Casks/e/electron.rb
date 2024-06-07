cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "30.1.0"
  sha256 arm:   "8d50e342977d934c12754e4780c6731dc23efc3c438e250f6c85bc17ecd8adb6",
         intel: "ca9d9485a993d7ebb5d259c65a7407901fcae97e92d7a8b5757a20790d9c1515"

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