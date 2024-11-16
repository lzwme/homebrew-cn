cask "widelands" do
  arch arm: "14-arm64", intel: "12-x86"

  version "1.2.1"
  sha256 arm:   "7067e26809ba92395644b58ced3d99b2ecd5f83844c913c1cae7290351cc6f38",
         intel: "de55c686a82c904c4e585cf93802af3b475ed330e5420b3ef9b4a23d649e6b9e"

  on_arm do
    depends_on macos: ">= :sonoma"
  end
  on_intel do
    depends_on macos: ">= :monterey"
  end

  url "https:github.comwidelandswidelandsreleasesdownloadv#{version}Widelands-#{version}-MacOS#{arch}.dmg",
      verified: "github.comwidelandswidelands"
  name "Widelands"
  desc "Free real-time strategy game like Settlers II"
  homepage "https:www.widelands.org"

  livecheck do
    url "https:www.widelands.orgwikiDownload"
    regex(href=.*?Widelands[._-]v?(\d+(?:\.\d+)+)[._-]MacOS#{arch}\.dmgi)
  end

  app "Widelands.app"

  zap trash: "~.widelands"
end