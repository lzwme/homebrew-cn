cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "28.0.0"
  sha256 arm:   "d64947fee370a3b111f170399969977959848f2a2f544a1ae5dc081fc2df75cf",
         intel: "a5fdc70519b2c17a708920af2b998fc067ff0a18ba9f97d690cfab6bac23bd7a"

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