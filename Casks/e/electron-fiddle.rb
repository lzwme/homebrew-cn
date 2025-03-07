cask "electron-fiddle" do
  arch arm: "arm64", intel: "x64"

  version "0.36.6"
  sha256 arm:   "ddd35b9f95e89945f2af4c0d3d8eed7861e5db89b586c63a2b95295a114d67a7",
         intel: "3761e355da74c31fe907cb2966bdb17010f4c63c9d8df68d64667c3ab2bd23fe"

  url "https:github.comelectronfiddlereleasesdownloadv#{version}Electron.Fiddle-darwin-#{arch}-#{version}.zip",
      verified: "github.comelectronfiddle"
  name "Electron Fiddle"
  desc "Create and play with small Electron experiments"
  homepage "https:www.electronjs.orgfiddle"

  livecheck do
    url :homepage
    regex(href=.*?Electron[._-]Fiddle[._-]darwin[._-]#{arch}[._-]v?(\d+(?:\.\d+)+)\.zipi)
  end

  depends_on macos: ">= :big_sur"

  app "Electron Fiddle.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.fiddle.sfl*",
    "~LibraryApplication SupportElectron Fiddle",
    "~LibraryCachescom.electron.fiddle*",
    "~LibraryCachesfiddle-core",
    "~LibraryHTTPStoragescom.electron.fiddle",
    "~LibraryPreferencescom.electron.fiddle*.plist",
    "~LibrarySaved Application Statecom.electron.fiddle.savedState",
  ]
end