cask "kube-forwarder" do
  version "1.5.1"
  sha256 "683bcd380885787d653bfb21b39fda05ed786b09abe311c856ae4032859f3d5f"

  url "https:github.compixel-pointkube-forwarderreleasesdownloadv#{version}kube-forwarder.dmg",
      verified: "github.compixel-pointkube-forwarder"
  name "Kube Forwarder"
  homepage "https:kube-forwarder.pixelpoint.io"

  app "Kube Forwarder.app"
end