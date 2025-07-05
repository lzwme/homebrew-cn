cask "via" do
  version "3.0.0"
  sha256 "30f9f81154a8ee9c0cf19f4fb1a3d6ca9a448f765122845db1e190b9f583d16b"

  url "https://ghfast.top/https://github.com/the-via/releases/releases/download/v#{version}/via-#{version}-mac.dmg",
      verified: "github.com/the-via/releases/"
  name "VIA"
  desc "Keyboard configurator"
  homepage "https://caniusevia.com/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "VIA.app"

  zap trash: [
    "~/Library/Application Support/VIA",
    "~/Library/Application Support/via-nativia",
    "~/Library/Logs/VIA",
    "~/Library/Preferences/org.via.configurator.plist",
  ]

  caveats do
    requires_rosetta
  end
end