cask "neo4j" do
  # NOTE: "4" is not a version number, but an intrinsic part of the product name
  version "1.6.1"
  sha256 "da8e8506e49461b03256cb4053034869e7d46f88090e1c81c8669dc2e6b5c2c1"

  url "https://dist.neo4j.org/neo4j-desktop/mac/Neo4j%20Desktop-#{version}.dmg",
      verified: "dist.neo4j.org/neo4j-desktop/mac/"
  name "Neo4j Desktop"
  desc "Developer IDE or Management Environment for Neo4j instances"
  homepage "https://neo4j.com/download/"

  livecheck do
    url "https://neo4j.com/deployment-center/"
    regex(%r{href=.*?/neo4j-desktop/.*?flavour=osx.*?release=(\d+(?:\.\d+)+)}i)
  end

  app "Neo4j Desktop.app"

  zap trash: [
    "~/Library/Application Support/com.Neo4j.Relate",
    "~/Library/Application Support/Neo4j Desktop",
    "~/Library/Caches/com.Neo4j.Relate",
    "~/Library/Logs/Neo4j Desktop",
    "~/Library/Preferences/com.neo4j.neo4j-desktop.plist",
    "~/Library/Saved Application State/com.neo4j.neo4j-desktop.savedState",
  ]

  caveats do
    requires_rosetta
  end
end