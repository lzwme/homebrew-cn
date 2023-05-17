cask "jdkmon" do
  version "17.0.59"

  on_intel do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}.pkg"
    sha256 "fa3e91c2da45adb8e7a4ddd7a86eb1524d4a6c3f21475ecbd97093cbc9d2b49d"
    pkg "JDKMon-#{version}.pkg"
  end
  on_arm do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}-aarch64.pkg"
    sha256 "9349ceb15efabc7b67c06b1d4bfb2a30c9861dbcc59a501da2f8fd01b0de9a67"
    pkg "JDKMon-#{version}-aarch64.pkg"
  end

  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end