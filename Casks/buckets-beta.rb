cask "buckets-beta" do
  version "0.71.0"
  sha256 "bc4d6fafb81c98b56cf59264e336fbb7d5e101a9f282e6b24c85b555eb520998"

  url "https://ghproxy.com/https://github.com/buckets/desktop-beta/releases/download/v#{version}/Buckets-Beta-#{version}.dmg",
      verified: "github.com/buckets/desktop-beta/"
  name "Buckets Beta"
  desc "Budgeting tool"
  homepage "https://www.budgetwithbuckets.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Buckets Beta.app"

  zap trash: [
    "~/Library/Application Support/Buckets Beta",
    "~/Library/Preferences/com.onepartrain.buckets.desktopbeta.plist",
  ]
end