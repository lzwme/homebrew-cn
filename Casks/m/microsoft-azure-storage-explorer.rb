cask "microsoft-azure-storage-explorer" do
  arch arm: "arm64", intel: "x64"

  version "1.39.0"
  sha256 arm:   "87a02b2dc26f0ab1d23dc40f0c1cc64dcfd97d32e19f010c5291a43bb23280f8",
         intel: "80f9f5a7de5d7c0a6395478a450621973a8cd1ca68616a50764016d5778eb5d8"

  url "https:github.commicrosoftAzureStorageExplorerreleasesdownloadv#{version}StorageExplorer-darwin-#{arch}.zip",
      verified: "github.commicrosoftAzureStorageExplorer"
  name "Microsoft Azure Storage Explorer"
  desc "Explorer for Azure Storage"
  homepage "https:azure.microsoft.comen-usfeaturesstorage-explorer"

  depends_on macos: ">= :catalina"

  app "Microsoft Azure Storage Explorer.app"

  zap trash: [
    "~LibraryApplication SupportStorageExplorer",
    "~LibraryLogsStorageExplorer",
    "~LibraryPreferencescom.microsoft.StorageExplorer.plist",
  ]
end