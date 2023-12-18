cask "microsoft-azure-storage-explorer" do
  arch arm: "arm64", intel: "x64"

  version "1.32.1"
  sha256 arm:   "4ae2f5155cc684c1c87963d8e9031627798fc2032b2e8e9255c495597b8ba6cd",
         intel: "00d67162c9c2b9057e5328780400de3a31f13c89a48786a307f167cd934f8793"

  url "https:github.commicrosoftAzureStorageExplorerreleasesdownloadv#{version}StorageExplorer-darwin-#{arch}.zip",
      verified: "github.commicrosoftAzureStorageExplorer"
  name "Microsoft Azure Storage Explorer"
  desc "Explorer for Azure Storage"
  homepage "https:azure.microsoft.comen-usfeaturesstorage-explorer"

  app "Microsoft Azure Storage Explorer.app"

  zap trash: [
    "~LibraryApplication SupportStorageExplorer",
    "~LibraryLogsStorageExplorer",
    "~LibraryPreferencescom.microsoft.StorageExplorer.plist",
  ]
end