cask "buckets@beta" do
  arch arm: "arm64", intel: "amd64"

  version "0.78.0"
  sha256 arm:   "6635d9c6a2d46dfa5b92937460a71cf630a5b59a6fe07efa74a575f1b906c369",
         intel: "0e7a3fad75d0fd6f74242a35688e359b5056766908a0e59ec30bc550831a9be2"

  url "https:github.combucketsdesktop-betareleasesdownloadv#{version}Buckets-Beta-#{arch}-#{version}.dmg",
      verified: "github.combucketsdesktop-beta"
  name "Buckets Beta"
  desc "Budgeting tool"
  homepage "https:www.budgetwithbuckets.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Buckets Beta.app"

  zap trash: [
    "~LibraryApplication SupportBuckets Beta",
    "~LibraryPreferencescom.onepartrain.buckets.desktopbeta.plist",
  ]
end