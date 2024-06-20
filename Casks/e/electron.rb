cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "31.0.2"
  sha256 arm:   "1e0b387c56dd430b4ce7c8dff0730dea82a3cc8d20f7fe0ff7edfa99c9dfc0e8",
         intel: "59a9d2ea735fe2c0b1a02f84a0dcb7c6fed3c8a0556bfbd89994de93eec4ba35"

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