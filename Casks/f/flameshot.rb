cask "flameshot" do
  version "12.1.0"
  sha256 "70fa1cb9990093b00d184eace8e6c5f1cfefe33decb8ab051141a3847439ff14"

  url "https:github.comflameshot-orgflameshotreleasesdownloadv#{version}flameshot.dmg",
      verified: "github.comflameshot-orgflameshot"
  name "Flameshot"
  desc "Screenshot software"
  homepage "https:flameshot.org"

  depends_on macos: ">= :catalina"

  app "flameshot.app"

  zap trash: "~.configflameshotflameshot.ini"

  caveats do
    requires_rosetta
  end
end