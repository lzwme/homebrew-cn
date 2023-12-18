cask "trezor-bridge" do
  version "2.0.27"
  sha256 "a8a5352f888467cb1bc3b4273ee26c7f0da2a58f60e31aeffea46153aa03be07"

  url "https:github.comtrezorwebwallet-datarawmasterbridge#{version}trezor-bridge-#{version}.pkg",
      verified: "github.comtrezorwebwallet-data"
  name "TREZOR Bridge"
  desc "Facilitates communication between the Trezor device and supported browsers"
  homepage "https:wallet.trezor.io"

  livecheck do
    url "https:raw.githubusercontent.comtrezorwebwallet-datamasterbridgelatest"
    regex((\d+(?:\.\d+)+)i)
  end

  pkg "trezor-bridge-#{version}.pkg"

  uninstall pkgutil:   "com.bitcointrezor.pkg.TREZORBridge*",
            launchctl: "com.bitcointrezor.trezorBridge.trezord",
            delete:    "ApplicationsUtilitiesTREZOR Bridge"

  zap trash: "~LibraryLogstrezord.log"
end