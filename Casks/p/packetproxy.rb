cask "packetproxy" do
  version "2.2.0"
  sha256 "b25aa90db773bb8d00871db777d383c6de292ae2dad448102f50702a9c0790fc"

  url "https:github.comDeNAPacketProxyreleasesdownload#{version}PacketProxy-#{version}-Installer-Mac-Signed.dmg"
  name "PacketProxy"
  desc "Local proxy written in Java"
  homepage "https:github.comDeNAPacketProxy"

  app "PacketProxy.app"

  zap trash: [
    "~.packetproxy",
    "~LibrarySaved Application Statepacketproxy",
  ]

  caveats do
    requires_rosetta
  end
end