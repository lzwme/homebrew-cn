cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "21.0.0"
  sha256 arm:   "a901c0a122320f7cb5fb2feedf9e22804969d30047da27596ce709c687d033a1",
         intel: "2bdd9434a8dd4a0baca75030017e824b4e5ce615f8a73afe6313f3459bd0b18f"

  url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end