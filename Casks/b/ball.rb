cask "ball" do
  version "1"
  sha256 "f3b1794971cc34fadcd817c8c4ed1ad9e791143254696fb6e78fea1294bccbd1"

  url "https:github.comnate-parrottballreleasesdownloadv#{version}Ball.dmg"
  name "Ball"
  desc "Utility that adds a ball to your dock"
  homepage "https:github.comnate-parrottball"

  depends_on macos: ">= :ventura"

  app "Ball.app"

  # No zap stanza required
end