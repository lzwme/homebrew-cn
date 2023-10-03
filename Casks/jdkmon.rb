cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "17.0.77"
  sha256 arm:   "241ec52c990da1e1e7c1f3f7745238d36b7d52acf671ca203f0135e5d1a945fd",
         intel: "cc98133fc2f3d67fe22ff041e0c8358870681c09ce7f506c5218af67a054a7c1"

  url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end