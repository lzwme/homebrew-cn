cask "lazpaint" do
  version "7.3"
  sha256 "eaac2b5776ad229a0f4496c407d4cf648dcc36626f2574486f0528916aa7a61c"

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

  zap trash: [
    "~.configlazpaint",
    "~.configlazpaint.cfg",
    "~LibraryCachescom.company.lazpaint",
    "~LibraryHTTPStoragescom.company.lazpaint",
    "~LibrarySaved Application Statecom.company.lazpaint.savedState",
  ]

  caveats do
    requires_rosetta
  end
end