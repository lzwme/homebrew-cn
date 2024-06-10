cask "font-migmix-1p" do
  version "2020.0307"
  sha256 "586660e48dc24f95c6fed49852eedb0185485ffc731cc4128acd10fd98813b8c"

  url "https:github.comitouhiromixfont-mplus-ipareleasesdownloadv#{version}migmix-1p-#{version.no_dots}.zip",
      verified: "github.comitouhiromixfont-mplus-ipa"
  name "MigMix 1P"
  homepage "https:itouhiro.github.iomixfont-mplus-ipamigmix"

  livecheck do
    url :homepage
    strategy :page_match do |page|
      page.scan(href=.*migmix-1p[._-]v?(\d+(?:\.\d+)*)\.zip"i)
          .map { |match| match[0].insert(4, ".") }
    end
  end

  font "migmix-1p-#{version.no_dots}migmix-1p-bold.ttf"
  font "migmix-1p-#{version.no_dots}migmix-1p-regular.ttf"

  # No zap stanza required
end