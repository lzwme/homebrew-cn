cask "provisionql" do
  version "1.6.4"
  sha256 "b76751b596e10b806bd75c643a09bcbf1680b6635f57c4feefa67bee7799f5df"

  url "https://ghfast.top/https://github.com/ealeksandrov/ProvisionQL/releases/download/#{version}/ProvisionQL.zip"
  name "ProvisionQL"
  desc "Quick Look plugin for mobile apps and provisioning profiles"
  homepage "https://github.com/ealeksandrov/ProvisionQL"

  no_autobump! because: :requires_manual_review

  qlplugin "ProvisionQL.qlgenerator"

  # No zap stanza required

  caveats <<~EOS
    To prevent mobileprovision Quick Look override by Xcode:

      https://github.com/ealeksandrov/ProvisionQL/issues/20
  EOS
end