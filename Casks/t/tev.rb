cask "tev" do
  version "1.28"
  sha256 "7d2ada6dd12d837c8ec3117c0fa8dcdfc7530d948f38e40a7652de2fc80d3006"

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