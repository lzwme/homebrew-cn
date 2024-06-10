cask "font-migu-1m" do
  version "2020.0307"
  sha256 "e4806d297e59a7f9c235b0079b2819f44b8620d4365a8955cb612c9ff5809321"

  url "https:github.comitouhiromixfont-mplus-ipareleasesdownloadv#{version}migu-1m-#{version.no_dots}.zip",
      verified: "github.comitouhiromixfont-mplus-ipa"
  name "Migu 1M"
  homepage "https:itouhiro.github.iomixfont-mplus-ipamigu"

  livecheck do
    url :homepage
    strategy :page_match do |page|
      page.scan(href=.*migu-1m[._-]v?(\d+(?:\.\d+)*)\.zip"i)
          .map { |match| match[0].insert(4, ".") }
    end
  end

  font "migu-1m-#{version.no_dots}migu-1m-bold.ttf"
  font "migu-1m-#{version.no_dots}migu-1m-regular.ttf"

  # No zap stanza required
end