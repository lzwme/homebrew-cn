cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "17.0.71"
  sha256 arm:   "3575713234517a542edc3ab0ec6dbb8022368542b2dd45b19f95e13d0643c1cd",
         intel: "079a247d5358b97748b871667740f5436cbb773804e0b5d4693f40ff1a32f059"

  url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end