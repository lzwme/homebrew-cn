cask "buckets-beta" do
  arch arm: "arm64", intel: "amd64"

  version "0.73.1"
  sha256 arm:   "66f310dee1c3df1f47d3ecc37135caf5dffe6168caf27d2e41b2fd3b3e1f3168",
         intel: "6189a06cd63c890bac49b2a2e0739cbfd0c9df89f48fc7c11638552191c14d29"

  url "https:github.combucketsdesktop-betareleasesdownloadv#{version}Buckets-Beta-#{arch}-#{version}.dmg",
      verified: "github.combucketsdesktop-beta"
  name "Buckets Beta"
  desc "Budgeting tool"
  homepage "https:www.budgetwithbuckets.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Buckets Beta.app"

  zap trash: [
    "~LibraryApplication SupportBuckets Beta",
    "~LibraryPreferencescom.onepartrain.buckets.desktopbeta.plist",
  ]
end