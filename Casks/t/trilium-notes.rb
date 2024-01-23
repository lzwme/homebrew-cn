cask "trilium-notes" do
  version "0.62.6"
  sha256 "abe1cee54730c1874cd12c4086bb05b546fee87c48074564637c508694a334a8"

  url "https:github.comzadamtriliumreleasesdownloadv#{version}trilium-mac-x64-#{version}.zip"
  name "Trilium Notes"
  desc "Personal knowledge base"
  homepage "https:github.comzadamtrilium"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "trilium-mac-x64Trilium Notes.app"

  zap trash: [
    "~LibraryApplication SupportTrilium Notes",
    "~LibraryApplication Supporttrilium-data",
    "~LibraryPreferencescom.electron.trilium-notes.plist",
    "~LibrarySaved Application Statecom.electron.trilium-notes.savedState",
  ]
end