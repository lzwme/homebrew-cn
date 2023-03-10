cask "deadbolt" do
  version "0.1.0"
  sha256 "c302f1c532082b200d844d17cd8feadc61821d97591fb5a0dbb1bb97c3a5981b"

  url "https://ghproxy.com/https://github.com/alichtman/deadbolt/releases/download/#{version}/Deadbolt-#{version}.dmg"
  name "Deadbolt"
  homepage "https://github.com/alichtman/deadbolt"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Deadbolt.app"

  zap trash: [
    "~/Library/Application Support/deadbolt",
    "~/Library/Preferences/org.alichtman.deadbolt.plist",
    "~/Library/Saved Application State/org.alichtman.deadbolt.savedState",
  ]
end