cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "33.2.0"
  sha256 arm:   "b78ec0f21a12effc6830b6ac70a71e226f3898dd1c2449b5230e071211fb4a73",
         intel: "08a345c459103334643df9a093c4eab73eb3bd57bc86e75ca46e8e38b94bb2eb"

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