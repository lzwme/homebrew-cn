cask "trilium-notes" do
  version "0.63.3"
  sha256 "3a09cca9a7daf5d60e6f565528d8a523c4cda1e206a770acb3203c991c323555"

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