cask "wire" do
  version "3.32.4589"
  sha256 "3c30190a7920ce56aeb1db70c9c2be3c77e9fb398bdf75675fa4730ac8014d9e"

  url "https:github.comwireappwire-desktopreleasesdownloadmacos%2F#{version}Wire.pkg",
      verified: "github.comwireappwire-desktop"
  name "Wire"
  desc "Collaboration platform focusing on security"
  homepage "https:wire.com"

  livecheck do
    url :url
    regex(%r{^macos[._-]v?(\d+(?:\.\d+)+)$}i)
  end

  pkg "Wire.pkg"

  uninstall pkgutil: "com.wearezeta.zclient.mac",
            signal:  [
              ["TERM", "com.wearezeta.zclient.mac.helper"],
              ["TERM", "com.wearezeta.zclient.mac"],
            ]

  zap trash: "~LibraryContainerscom.wearezeta.zclient.mac"
end