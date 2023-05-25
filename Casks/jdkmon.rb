cask "jdkmon" do
  version "17.0.61"

  on_intel do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}.pkg"
    sha256 "179c8aeef4e4bb82e1670f1542b970f32f7379d0705158fe31807b501b4e59bf"
    pkg "JDKMon-#{version}.pkg"
  end
  on_arm do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}-aarch64.pkg"
    sha256 "37c2a753d2e00ab2650e302cdad471391958dc6f5b46a94cd9e601d26a007790"
    pkg "JDKMon-#{version}-aarch64.pkg"
  end

  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end