cask "lazpaint" do
  version "7.2.2"
  sha256 "f7abc6fde628ea057ea9076acc156449b9e2e92d9d49f596cb6368850cc22c51"

  url "https:github.combgrabitmaplazpaintreleasesdownloadv#{version}lazpaint#{version}_macos64.dmg",
      verified: "github.combgrabitmaplazpaint"
  name "LazPaint"
  desc "Image editor written in Lazarus"
  homepage "https:bgrabitmap.github.iolazpaint"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "LazPaint.app"

  caveats do
    requires_rosetta
  end
end