cask "trilium-notes" do
  version "0.63.5"
  sha256 "576d0c4dea812f8bb8a633aa715855d30a9db63e88dec638683873a57741be94"

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