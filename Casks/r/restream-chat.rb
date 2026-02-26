cask "restream-chat" do
  version "2.6.9"
  sha256 "53e554fa174d3d5e5bb9477296aa01e36d46e123075a49ccf9e5b63c8a1ea13b"

  url "https://chat-client.restream.io/Restream+Chat-#{version}.dmg"
  name "Restream Chat"
  desc "Keep your streaming chats in one place"
  homepage "https://restream.io/chat/"

  livecheck do
    url "https://website-backend.restream.io/v2/public/chat/download/mac"
    strategy :header_match
  end

  app "Restream Chat.app"

  zap trash: "~/Library/Application Support/Restream Chat"

  caveats do
    requires_rosetta
  end
end