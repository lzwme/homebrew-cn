cask "bitmessage" do
  version "0.6.3.2"
  sha256 "40a78384a7a0613333dd76aaafc8ebeb08eb1ef02fceb0925763ce289ec5888b"

  url "https:github.comBitmessagePyBitmessagereleasesdownload#{version}bitmessage-v#{version}.dmg",
      verified: "github.comBitmessagePyBitmessage"
  name "Bitmessage"
  desc "P2P communications protocol"
  homepage "https:bitmessage.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-02-22", because: :unmaintained

  app "Bitmessage.app"

  caveats do
    requires_rosetta
  end
end