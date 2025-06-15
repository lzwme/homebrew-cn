cask "strawberry-wallpaper" do
  version "1.4.2"
  sha256 "733632a104fec8efc5024677332978d92d3375b00f877b50a95d0f450184f8e9"

  url "https:github.comaitexiaoyStrawberry-Wallpaperreleasesdownload#{version}Strawberry.Wallpaper-mac.dmg",
      verified: "github.comaitexiaoyStrawberry-Wallpaper"
  name "Strawberry Wallpaper"
  desc "Automatically update wallpapers of major galleries"
  homepage "https:aitexiaoy.github.ioStrawberry-Wallpaper"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  app "Strawberry Wallpaper.app"

  caveats do
    requires_rosetta
  end
end