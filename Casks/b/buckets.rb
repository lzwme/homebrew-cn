cask "buckets" do
  version "0.71.1"
  sha256 "fd96fc00a3f8f270fc643a15aa69d27ba2fddc021fe325330467137f2a896d9f"

  url "https:github.combucketsapplicationreleasesdownloadv#{version}Buckets-#{version}.dmg",
      verified: "github.combucketsapplication"
  name "Buckets"
  desc "Budgeting tool"
  homepage "https:www.budgetwithbuckets.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Buckets.app"

  zap trash: [
    "~LibraryApplication SupportBuckets",
    "~LibraryPreferencescom.github.buckets.application.plist",
  ]
end