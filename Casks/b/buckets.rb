cask "buckets" do
  arch arm: "arm64", intel: "amd64"

  version "0.72.1"
  sha256 arm:   "0150a22b048f01563359f8b3fd11c3666b43bbf0d9618934d0529697183eb09e",
         intel: "3f9f6a5b4b1cfa8b05d6837bd7f072c01447af517d13d01be695606d66bfd840"

  url "https:github.combucketsapplicationreleasesdownloadv#{version}Buckets-#{arch}-#{version}.dmg",
      verified: "github.combucketsapplication"
  name "Buckets"
  desc "Budgeting tool"
  homepage "https:www.budgetwithbuckets.com"

  livecheck do
    url :url
    strategy :github_latest
  end

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