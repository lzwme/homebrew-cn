cask "macos-catalina-patcher" do
  version "1.4.7"
  sha256 "c71ac58e71373de1a38ae767ea4a0ec92ab48aade074f873178135d2190d8acb"

  # github.com was verified as official when first introduced to the cask
  url "https://ghproxy.com/https://github.com/dosdude1/macos-catalina-patcher/releases/download/#{version}/macOS.Catalina.Patcher.dmg",
      verified: "github.com/dosdude1/macos-catalina-patcher"
  appcast "http://dosdude1.com/catalina/changelog.html"
  name "macOS Catalina Patcher"
  desc "Installer builder for Catalina for unsupported Apple machines"
  homepage "http://dosdude1.com/catalina/"

  app "macOS Catalina Patcher.app"
end