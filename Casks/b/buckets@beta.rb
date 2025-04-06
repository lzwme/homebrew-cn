cask "buckets@beta" do
  arch arm: "arm64", intel: "amd64"

  version "0.79.0"
  sha256 arm:   "e06daa8ec0a3520864b51ab231615c8c42bb3c5d670c84deb5ef2093b7706ab7",
         intel: "431ac6650475fa84eea1bd80b7c63e06122a915928bc1979c0a617cf7ffe9e69"

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