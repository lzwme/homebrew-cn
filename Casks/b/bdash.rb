cask "bdash" do
  version "1.18.0"
  sha256 "51668729275b4d7d227f79186dedb0c8779477ef82111bc7c226fb8dc22ec5c2"

  url "https://ghfast.top/https://github.com/bdash-app/bdash/releases/download/v#{version}/Bdash-#{version}-mac.zip"
  name "Bdash"
  desc "Simple SQL Client for lightweight data analysis"
  homepage "https://github.com/bdash-app/bdash"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Bdash.app"

  zap trash: [
    "~/.bdash",
    "~/Library/Application Support/Bdash",
    "~/Library/Logs/Bdash",
    "~/Library/Preferences/io.bdash.plist",
    "~/Library/Saved Application State/io.bdash.savedState",
  ]

  caveats do
    requires_rosetta
  end
end