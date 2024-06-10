cask "font-migmix-2p" do
  version "2023.1123"
  sha256 "be93ac23840224586b58bdd7a468d22e28affa6e49f4e2812bb03961706ac278"

  url "https:github.comitouhiromixfont-mplus-ipareleasesdownloadv#{version}migmix-2p-#{version.no_dots}.zip",
      verified: "github.comitouhiromixfont-mplus-ipa"
  name "MigMix 2P"
  homepage "https:itouhiro.github.iomixfont-mplus-ipamigmix"

  livecheck do
    url :homepage
    strategy :page_match do |page|
      page.scan(href=.*migmix-2p[._-]v?(\d+(?:\.\d+)*)\.zip"i)
          .map { |match| match[0].insert(4, ".") }
    end
  end

  font "migmix-2p-#{version.no_dots}migmix-2p-bold.ttf"
  font "migmix-2p-#{version.no_dots}migmix-2p-regular.ttf"

  # No zap stanza required
end