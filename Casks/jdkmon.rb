cask "jdkmon" do
  version "17.0.69"

  on_intel do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}.pkg"
    sha256 "8ee7621291135f1188c7801178b1e2fd58a6fc647edb5530a01c4c4f66e4a5c9"
    pkg "JDKMon-#{version}.pkg"
  end
  on_arm do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}-aarch64.pkg"
    sha256 "e5afcbc994b4e1f622fa8f48725fe76afb7055183d09e9483a79e545a547060a"
    pkg "JDKMon-#{version}-aarch64.pkg"
  end

  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end