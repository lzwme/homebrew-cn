cask "tev" do
  version "1.26"
  sha256 "40a71c355171d4fc2159482ce6c7e56ce05b6d9e4e4a035e97a6d1c7c24d718b"

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