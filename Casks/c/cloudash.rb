cask "cloudash" do
  version "1.22.1"
  sha256 "73451741b9ddf1d26eecd2ae21d92602e2c2eae414eab6329243fa75cd18428c"

  url "https:github.comcloudashdevcloudashreleasesdownload#{version}Cloudash-#{version}.dmg",
      verified: "github.comcloudashdevcloudash"
  name "cloudash"
  desc "Monitoring and troubleshooting for serverless architectures"
  homepage "https:cloudash.dev"

  depends_on macos: ">= :high_sierra"

  app "Cloudash.app"

  zap trash: [
    "~LibraryApplication Supportcloudash",
    "~LibraryLogsCloudash",
    "~LibraryPreferencesdev.cloudash.cloudash.plist",
    "~LibrarySaved Application Statedev.cloudash.cloudash.savedState",
  ]
end