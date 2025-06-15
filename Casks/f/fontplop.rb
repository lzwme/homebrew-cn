cask "fontplop" do
  version "1.3.0"
  sha256 "0ada8c9040bb3da489965b917990f6d88da23c8fec5602f798c91db7e2aafb0e"

  url "https:github.commatthewgonzalezfontplopreleasesdownloadv#{version}fontplop-#{version}.dmg"
  name "Fontplop"
  desc "Open Source Webfont Converter"
  homepage "https:github.commatthewgonzalezfontplop"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-10", because: :unmaintained

  app "fontplop.app"

  caveats do
    requires_rosetta
  end
end