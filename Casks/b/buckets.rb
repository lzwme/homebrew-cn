cask "buckets" do
  arch arm: "arm64", intel: "amd64"

  version "0.75.0"
  sha256 arm:   "61d576908eff4cc2970bb5809a34ac437167e759211abba67b50a1f76bae0214",
         intel: "91a7fcbbeb603d00b6987ab94a4630176702b4afd30dd999687339a48673dd9b"

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