cask "makeracam" do
  version "0.2.1.5"
  sha256 "e3dafbee2124819a6db9375f82cf1d15190b2b46a3f2684df90269e4bcc0a42a"

  url "https://ghfast.top/https://github.com/MakeraInc/MakeraCAM/releases/download/v#{version}/MakeraCAM_Mac_v#{version}.dmg",
      verified: "github.com/MakeraInc/MakeraCAM/"
  name "MakeraCAM"
  desc "CAM software for Makera CNCs"
  homepage "https://www.makera.com/pages/software"

  depends_on macos: ">= :catalina"

  app "MakeraCAM.app"

  zap trash: "~/Library/Application Support/MakeraCAM"

  caveats do
    requires_rosetta
  end
end