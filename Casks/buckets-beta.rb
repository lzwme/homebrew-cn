cask "buckets-beta" do
  arch arm: "arm64", intel: "amd64"

  version "0.73.2"
  sha256 arm:   "ceac36eb02b1464cad3ce37cbccde3ab2a626e70afcbf1436e84ca9722a77837",
         intel: "6570a552843d4d4e1fa534637d8daba296f34bb6d5555f7cce2aa5e9a2ba5f81"

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