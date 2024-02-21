cask "electron" do
  arch arm: "arm64", intel: "x64"

  version "29.0.0"
  sha256 arm:   "b413a2d5784d2ac5f370081c8e178a53a22ac64085d8f1b9ab61e2843397cfa6",
         intel: "ca5d5f4358ee28f97abba80dcdaf49495e1d91373eecaa87e1fb10b571eb5996"

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