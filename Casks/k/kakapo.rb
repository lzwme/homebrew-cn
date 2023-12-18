cask "kakapo" do
  version "1.3.0"
  sha256 "4f89f2d651b88e7c13bce3cccefc4929e83a5f509dae102f071ecd80aab9d524"

  url "https:github.combluedanielKakapo-appreleasesdownloadv#{version}Kakapo-#{version}-Mac.zip",
      verified: "github.combluedanielKakapo-app"
  name "Kakapo"
  desc "Open-source ambient sound mixer"
  homepage "http:www.kakapo.coapp.html"

  app "Kakapo.app"
end