cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "17.0.75"
  sha256 arm:   "8bec575ef991160c134c14f45a78afd9ee20c6a4d929cb9208ffcec2b5481f5a",
         intel: "4747b36b31928e46794dc8944005264daa0a123b0a651539a3c538582deb7418"

  url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end