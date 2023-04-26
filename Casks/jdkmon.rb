cask "jdkmon" do
  version "17.0.47"

  on_intel do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}.pkg"
    sha256 "7f3eec5bb1044f081c75a6841e1e684f9bd628262c3a3b85bbdde78ace9efdab"
    pkg "JDKMon-#{version}.pkg"
  end
  on_arm do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}-aarch64.pkg"
    sha256 "d53355fa7886ad02abf259d4dec3a73641afad20037dc48758a5b6701be7182e"
    pkg "JDKMon-#{version}-aarch64.pkg"
  end

  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end