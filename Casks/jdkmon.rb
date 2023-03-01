cask "jdkmon" do
  version "17.0.45"

  on_intel do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}.pkg"
    sha256 "fe2ce58354627846397dd883c0d7381344190cbec7a80059454e2e7c439c9fcd"
    pkg "JDKMon-#{version}.pkg"
  end
  on_arm do
    url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}-aarch64.pkg"
    sha256 "e8c7ec674204e81202c3fd78e262ed309868ad92e9fa73f96d4ef506bed3a590"
    pkg "JDKMon-#{version}-aarch64.pkg"
  end

  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end