cask "provisioning" do
  version "1.0.4"
  sha256 "554590ab653776babbc453892653d052f1ec09c6473fc91f4a071f1a7a953144"

  url "https://ghfast.top/https://github.com/chockenberry/Provisioning/releases/download/#{version}/Provisioning-#{version}.zip"
  name "Provisioning"
  homepage "https://github.com/chockenberry/Provisioning"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-13", because: :unmaintained

  qlplugin "Provisioning-#{version}/Provisioning.qlgenerator"
end