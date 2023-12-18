cask "gb-studio" do
  version "3.1.0"
  sha256 "73d5d487962aab11268d281cad80e8fd42cf08e16e82c527a402acf63703a2ef"

  url "https:github.comchrismaltbygb-studioreleasesdownloadv#{version}gb-studio-mac.zip",
      verified: "github.comchrismaltbygb-studio"
  name "GB Studio"
  desc "Drag and drop retro game creator"
  homepage "https:www.gbstudio.dev"

  app "GB Studio.app"
end