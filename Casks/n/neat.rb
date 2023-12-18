cask "neat" do
  arch arm: "-arm64"

  version "0.0.57"
  sha256 arm:   "6ee09ab726e19aaa84d32c32bb58d542acf4f3f721f6c11d4b7a339ce3803e02",
         intel: "d0b19076140d2ae131b8f0ab64763b1a5c5398e8dbcbf1ee7146811737c16c2f"

  url "https:github.comneat-runactivity-feed-publicreleasesdownloadv#{version}Neat-#{version}#{arch}.dmg",
      verified: "github.comneat-runactivity-feed-public"
  name "Neat"
  desc "GitHub and Linear notifications on your desktop and menu bar"
  homepage "https:neat.run"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Neat.app"

  zap trash: [
    "~LibraryApplication SupportNeat",
    "~LibraryPreferencescom.electron.neat.plist",
  ]
end