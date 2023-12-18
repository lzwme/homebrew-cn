cask "provisioning" do
  version "1.0.4"
  sha256 "554590ab653776babbc453892653d052f1ec09c6473fc91f4a071f1a7a953144"

  url "https:github.comchockenberryProvisioningreleasesdownload#{version}Provisioning-#{version}.zip"
  name "Provisioning"
  homepage "https:github.comchockenberryProvisioning"

  qlplugin "Provisioning-#{version}Provisioning.qlgenerator"
end