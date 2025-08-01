cask "fspy" do
  version "1.0.3"
  sha256 "3aca686ea9d976580936279fbb3637698a3ba832d3cdd74dbbf79129b4dd2f56"

  url "https://ghfast.top/https://github.com/stuffmatic/fSpy/releases/download/v#{version}/fSpy-#{version}.dmg",
      verified: "github.com/stuffmatic/fSpy/"
  name "fSpy"
  desc "Still image camera matching"
  homepage "https://fspy.io/"

  no_autobump! because: :requires_manual_review

  app "fSpy.app"

  zap trash: "~/Library/Application Support/fspy"

  caveats do
    requires_rosetta
  end
end