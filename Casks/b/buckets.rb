cask "buckets" do
  arch arm: "arm64", intel: "amd64"

  version "0.72.2"
  sha256 arm:   "9f9104a700d5546fe55161b7c5e41ec12b2f57ff64d96236a13905cb508eb42c",
         intel: "a0b02ee94a648fcd26c7d4ad18abcf241ee89fa972ace8ede84ee741fdbfa1d0"

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