cask "tev" do
  version "1.27"
  sha256 "0ca0ffbd83a88c479ac3c3b70a833bb774e3f0b1ea76e771824f9002e7a055e4"

  url "https:github.comTom94tevreleasesdownloadv#{version}tev.dmg"
  name "tev"
  desc "HDR image comparison tool with an emphasis on OpenEXR images"
  homepage "https:github.comTom94tev"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :catalina"

  app "tev.app"

  zap trash: "~LibraryPreferencesorg.tom94.tev.plist"
end