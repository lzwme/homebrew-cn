cask "flameshot" do
  version "12.1.0"
  sha256 "70fa1cb9990093b00d184eace8e6c5f1cfefe33decb8ab051141a3847439ff14"

  url "https://ghfast.top/https://github.com/flameshot-org/flameshot/releases/download/v#{version}/flameshot.dmg",
      verified: "github.com/flameshot-org/flameshot/"
  name "Flameshot"
  desc "Screenshot software"
  homepage "https://flameshot.org/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "flameshot.app"

  zap trash: "~/.config/flameshot/flameshot.ini"

  caveats do
    requires_rosetta
  end
end