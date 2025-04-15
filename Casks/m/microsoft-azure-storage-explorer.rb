cask "microsoft-azure-storage-explorer" do
  arch arm: "arm64", intel: "x64"

  version "1.38.0"
  sha256 arm:   "200bbaa3c11a08add9b1238ed2445398b8ac5fb8e4d9c25ff167ea0c9cf63bb0",
         intel: "d67135eba6c0802bde47cf3a7048461fc41b5ace19884e19a8afcaa67e4947a6"

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