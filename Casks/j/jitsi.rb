cask "jitsi" do
  version "2.10.5550"
  sha256 "d902af9dde7b1fde6f76af5f97e4f27d6b853bd9d3e83b2fec5292dda787a0da"

  url "https:github.comjitsijitsireleasesdownloadJitsi-#{version.major_minor}jitsi-#{version}.dmg",
      verified: "github.comjitsijitsi"
  name "Jitsi"
  desc "Open-source video calls and chat"
  homepage "https:desktop.jitsi.org"

  livecheck do
    url "https:download.jitsi.orgjitsimacosxsparkleupdates.xml"
    strategy :sparkle do |item|
      item.url[-(\d+(?:\.\d+)*)\.dmgi, 1]
    end
  end

  app "Jitsi.app"

  zap trash: [
    "~LibraryApplication SupportJitsi",
    "~LibraryCachesJitsi",
    "~LibraryLogsJitsi",
    "~LibraryPreferencesorg.jitsi.jitsi.plist",
  ]
end