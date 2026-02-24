cask "soundanchor" do
  version "1.6.1"
  sha256 "90872e7cd66aeed0b9cf3ecab132be4f5b27743d485d5dc60903d5d0c9567444"

  url "https://kopiro.s3.amazonaws.com/soundanchor/soundanchor-#{version}.dmg",
      verified: "kopiro.s3.amazonaws.com/soundanchor/"
  name "SoundAnchor"
  desc "Audio device utility"
  homepage "https://apps.kopiro.me/soundanchor/"

  livecheck do
    url "https://kopiro.s3.eu-west-1.amazonaws.com/soundanchor/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "SoundAnchor.app"

  # No zap stanza required
end