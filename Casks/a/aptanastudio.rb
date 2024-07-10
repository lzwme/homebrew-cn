cask "aptanastudio" do
  version "3.7.2.201807301111"
  sha256 "02d0dccd808d1dd7a16ef1aab199e472726b8476cb65728f1f1ad06f6eca2363"

  url "https:github.comaptanastudio3releasesdownload#{version}Aptana_Studio_#{version.major}.dmg",
      verified: "github.comaptanastudio3"
  name "Aptana Studio"
  homepage "https:www.aptana.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "AptanaStudio.app"

  caveats do
    requires_rosetta
  end
end