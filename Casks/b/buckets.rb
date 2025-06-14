cask "buckets" do
  arch arm: "arm64", intel: "amd64"

  version "0.80.0"
  sha256 arm:   "2d7ec7a7d5cf1845c9f2c7adfb37426c7886ae10abec4cca7545cc022277b9c9",
         intel: "54528d1c01c90cc514bd7d534f541f453d3796676991846a04a3a971bfb76a5d"

  url "https:github.combucketsapplicationreleasesdownloadv#{version}Buckets-#{arch}-#{version}.dmg",
      verified: "github.combucketsapplication"
  name "Buckets"
  desc "Budgeting tool"
  homepage "https:www.budgetwithbuckets.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Buckets.app"

  zap trash: [
    "~LibraryApplication SupportBuckets",
    "~LibraryApplication SupportCachesbuckets-updater",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.buckets.application.sfl*",
    "~LibraryCachescom.github.buckets.application",
    "~LibraryCachescom.github.buckets.application.ShipIt",
    "~LibraryHTTPStoragescom.github.buckets.application",
    "~LibraryLogsBuckets",
    "~LibraryLogsDiagnosticReportsBuckets-*.ips",
    "~LibraryPreferencesByHostcom.github.buckets.application.ShipIt.*.plist",
    "~LibraryPreferencescom.github.buckets.application.plist",
    "~LibrarySaved Application Statecom.github.buckets.application.savedState,",
  ]
end