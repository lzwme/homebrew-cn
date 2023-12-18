cask "jitsi" do
  version "2.10.5550"
  sha256 "d902af9dde7b1fde6f76af5f97e4f27d6b853bd9d3e83b2fec5292dda787a0da"

  url "https:github.comjitsijitsireleasesdownloadJitsi-#{version.major_minor}jitsi-#{version}.dmg",
      verified: "github.comjitsijitsi"
  name "Jitsi"
  homepage "https:jitsi.org"

  livecheck do
    url "https:download.jitsi.orgjitsimacosxsparkleupdates.xml"
    strategy :sparkle do |item|
      item.url[-(\d+(?:\.\d+)*)\.dmgi, 1]
    end
  end

  app "Jitsi.app"
end