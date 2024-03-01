cask "buckets-beta" do
  arch arm: "arm64", intel: "amd64"

  version "0.73.4"
  sha256 arm:   "f5d5062af54205b3277319c66227f117d97718857fe89b42ec1a9db87ac3d429",
         intel: "c7f8da54de6d6f2cba56223a0cd5f50871c2e9b8f54b2d2649080b4dabfa669d"

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