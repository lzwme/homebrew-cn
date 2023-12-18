cask "cloudash" do
  version "1.22.0"
  sha256 "f9956be889126f8ea8143f241b1c0b4beb119404fda59b61cb3b59f56fc88470"

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