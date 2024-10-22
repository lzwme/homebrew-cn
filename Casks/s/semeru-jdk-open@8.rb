cask "semeru-jdk-open@8" do
  version "8u422-b05,openj9-0.46.1"
  sha256 "c758fbe798c571500326ebac680226e8c2290ae212d775182768147e6844d723"

  url "https:github.comibmruntimessemeru8-binariesreleasesdownloadjdk#{version.csv.first}_#{version.csv.second}ibm-semeru-open-jdk_x64_mac_#{version.csv.first.tr("-", "")}_#{version.csv.second}.pkg",
      verified: "github.comibmruntimessemeru8-binaries"
  name "IBM Semeru Runtime (JDK 8) Open Edition"
  desc "Production-ready JDK with the OpenJDK class libraries and the Eclipse OpenJ9 JVM"
  homepage "https:developer.ibm.comlanguagesjavasemeru-runtimes"

  livecheck do
    url :url
    regex(^(?:jdk)?(\d+u\d+)[._-](b\d+)[._-](.+?)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]}-#{match[1]},#{match[2]}" }
    end
  end

  pkg "ibm-semeru-open-jdk_x64_mac_#{version.csv.first.tr("-", "")}_#{version.csv.second}.pkg"

  uninstall pkgutil: "net.ibm-semeru-open.8.jdk"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end