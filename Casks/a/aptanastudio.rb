cask "aptanastudio" do
  version "3.7.2.201807301111"
  sha256 "02d0dccd808d1dd7a16ef1aab199e472726b8476cb65728f1f1ad06f6eca2363"

  url "https:github.comaptanastudio3releasesdownload#{version}Aptana_Studio_#{version.major}.dmg",
      verified: "github.comaptanastudio3"
  name "Aptana Studio"
  desc "IDE for web development"
  homepage "https:www.aptana.com"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-17", because: :unmaintained

  app "AptanaStudio.app"

  caveats do
    requires_rosetta
  end
end