cask "strawberry-wallpaper" do
  version "1.4.2"
  sha256 :no_check

  url "https:github.comaitexiaoyStrawberry-Wallpaperreleasesdownload#{version}Strawberry.Wallpaper-mac.dmg",
      verified: "github.comaitexiaoyStrawberry-Wallpaper"
  name "Strawberry Wallpaper"
  desc "Automatically update wallpapers of major galleries"
  homepage "https:aitexiaoy.github.ioStrawberry-Wallpaper"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "Strawberry Wallpaper.app"

  caveats do
    requires_rosetta
  end
end