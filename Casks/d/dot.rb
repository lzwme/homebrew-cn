cask "dot" do
  version "2.1.0"
  sha256 "2f1456f6346e82e92d21979c68e56c64befbb286287e604856af449718b81559"

  url "https://ghfast.top/https://github.com/prateekkeshari/dot-releases/releases/download/v#{version}/Dot-#{version}.dmg",
      verified: "github.com/prateekkeshari/dot-releases/"
  name "Dot"
  desc "Menu bar calendar with meeting reminders"
  homepage "https://www.trydot.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "Dot.app"

  zap trash: [
    "~/Library/Application Scripts/com.dot.app/",
    "~/Library/Caches/com.dot.app/",
    "~/Library/Containers/com.dot.app/",
  ]
end