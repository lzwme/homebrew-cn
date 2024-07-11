cask "touchbarserver" do
  version "1.6"
  sha256 "c3adffbaed14d12feaf5300995f78e63fbbc2a99733f76549f5a4b071ce86a82"

  url "https:github.combikkelbroedersTouchBarDemoAppreleasesdownloadv#{version}TouchBarServer.zip"
  name "TouchBarServer"
  homepage "https:github.combikkelbroedersTouchBarDemoApp"

  app "TouchBarServer.app"

  caveats do
    requires_rosetta
  end
end