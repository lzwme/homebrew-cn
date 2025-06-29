cask "pulse-sms" do
  version "4.5.3"
  sha256 "9e12b4a0b794ee4903ee59c57b10c5951a357f739c90bda387a81a55b9bdd73f"

  url "https:github.commaplemediapulse-sms-desktopreleasesdownloadv#{version}pulse-sms-#{version}.dmg",
      verified: "github.commaplemediapulse-sms-desktop"
  name "Pulse SMS"
  desc "Desktop client for Pulse SMS"
  homepage "https:home.pulsesms.appoverview"

  no_autobump! because: :requires_manual_review

  app "Pulse SMS.app"

  zap trash: [
    "~LibraryApplication Supportpulse-sms",
    "~LibraryLogspulse-sms",
  ]

  caveats do
    requires_rosetta
  end
end