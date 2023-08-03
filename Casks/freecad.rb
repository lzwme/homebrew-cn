cask "freecad" do
  arch arm: "arm64", intel: "intel_x86"

  version "0.21.0"
  sha256 arm:   "e12232d2f3411966f25837a4d5f2c14b72ea700b2a4dbb0a7b88f6b1da3044fb",
         intel: "271a3785a0ca68fab94ef6a7397ca9ed39cafbdce5bea19755b835462d8bceb0"

  url "https://ghproxy.com/https://github.com/FreeCAD/FreeCAD/releases/download/#{version}/FreeCAD-#{version}-mac-#{arch}.dmg",
      verified: "github.com/FreeCAD/FreeCAD/"
  name "FreeCAD"
  desc "3D parametric modeler"
  homepage "https://www.freecad.org//"

  livecheck do
    url "https://www.freecad.org/downloads.php"
    regex(/FreeCAD[._-]v?(\d+(?:\.\d+)+)[._-]mac[._-]#{arch}\.dmg/i)
  end

  depends_on macos: ">= :sierra"

  app "FreeCAD.app"

  zap trash: [
    "~/Library/Application Support/FreeCAD",
    "~/Library/Caches/FreeCAD",
    "~/Library/Preferences/FreeCAD",
    "~/Library/Preferences/com.freecad.FreeCAD.plist",
  ]
end