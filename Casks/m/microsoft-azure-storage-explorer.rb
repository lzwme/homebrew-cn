cask "microsoft-azure-storage-explorer" do
  arch arm: "arm64", intel: "x64"

  version "1.35.0"
  sha256 arm:   "723d9ead8ff6a563b4db294848bc589a0e4065aaf8b7f22d00c533272a7c1d32",
         intel: "c610835d3238e4432634984e0b83e4f7c194142ba5c04a5eaefc34a6ed048fdf"

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