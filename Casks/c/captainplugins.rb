cask "captainplugins" do
  version "7.4.1.10110"
  sha256 :no_check

  url "https://builds.mixedinkey.com/download/53/release/latest?key=dh-708a5f510d404bca9c44e2cecf5ced03"
  name "Captain Plugins Epic"
  desc "Music theory tool"
  homepage "https://mixedinkey.com/get-captain-epic/"

  livecheck do
    url :url
    regex(/filename=.*?CaptainPlugins[+._-]v?(\d+(?:\.\d+)+)\.zip/i)
    strategy :header_match
  end

  pkg "CaptainPlugins.pkg"

  uninstall pkgutil: "com.mixedinkey.CaptainPlugins.Epic.pkg"

  zap trash: [
    "~/Library/Application Support/Captain Plugins",
    "~/Music/Captain Plugins",
  ]
end