cask "microsoft-azure-storage-explorer" do
  arch arm: "arm64", intel: "x64"

  version "1.36.1"
  sha256 arm:   "82832675ea392ef9a20c0a470b96a5ea48ceda906c177e75bd0c8cf45c758565",
         intel: "24b4786954ca52d0092ca9ae5c44301de6382d78c2700c10f7ab779d68ae5b12"

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