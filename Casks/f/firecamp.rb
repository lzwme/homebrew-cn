cask "firecamp" do
  version "2.6.1"
  sha256 "8b7df7244da0e577a7a5793822af6144548a65024e6b1f8166513ec2435ccb08"

  url "https://firecamp.ams3.digitaloceanspaces.com/versions/mac/Firecamp-#{version}.dmg",
      verified: "firecamp.ams3.digitaloceanspaces.com/"
  name "Firecamp"
  desc "Multi-protocol API development platform"
  homepage "https://firecamp.io/"

  livecheck do
    url "https://firecamp.netlify.app/.netlify/functions/download?pt=mac"
    strategy :header_match
  end

  no_autobump! because: :requires_manual_review

  app "Firecamp.app"

  zap trash: [
    "~/.firecamp",
    "~/Library/Application Support/firecamp",
    "~/Library/Preferences/com.firecamp.app.plist",
  ]

  caveats do
    requires_rosetta
  end
end