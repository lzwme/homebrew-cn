cask "epichrome" do
  version "2.4.26"
  sha256 "690df70b5c8fc7104ad44965dfc509e61f5c2238638d793befdae19c1210a8d3"

  url "https:github.comdmarmorepichromereleasesdownloadv#{version}epichrome-#{version}.pkg"
  name "Epichrome"
  desc "Tool to create web-based applications that work like standalone apps"
  homepage "https:github.comdmarmorepichrome"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  pkg "epichrome-#{version}.pkg"

  uninstall pkgutil: "org.epichrome.Epichrome"
end