cask "halloy" do
  version "2026.3"
  sha256 "e4901c8d571e4de32e92d25c2bd51c4df79eb468a6d71ebddcdf403f5f5242a1"

  url "https://ghfast.top/https://github.com/squidowl/halloy/releases/download/#{version}/halloy.dmg",
      verified: "github.com/squidowl/halloy/"
  name "Halloy"
  desc "IRC client"
  homepage "https://halloy.chat/"

  depends_on macos: ">= :big_sur"

  app "Halloy.app"

  zap trash: [
    "~/Library/Application Support/halloy",
    "~/Library/Saved Application State/org.squidowl.halloy.savedState",
  ]
end