cask "semeru-jdk11-open" do
  arch arm: "aarch64", intel: "x64"

  version "11.0.22+7,openj9-0.43.0"
  sha256 arm:   "57cf3015d5c45aed38fd70095cd5b28e70667c8847462faa96a620b70fdf2f5a",
         intel: "dba721b2c1e274a8d2a696e1590d9a0ff735488fdc057c98911b12df408c5abd"

  url "https:github.comibmruntimessemeru#{version.major}-binariesreleasesdownloadjdk-#{version.csv.first}_#{version.csv.second}ibm-semeru-open-jdk_#{arch}_mac_#{version.csv.first.tr("+", "_")}_#{version.csv.second}.pkg",
      verified: "github.comibmruntimessemeru#{version.major}-binaries"
  name "IBM Semeru Runtime (JDK 11) Open Edition"
  desc "Production-ready JDK with the OpenJDK class libraries and the Eclipse OpenJ9 JVM"
  homepage "https:developer.ibm.comlanguagesjavasemeru-runtimes"

  livecheck do
    url :stable
    regex(^jdk[._-](\d+(?:[.+]\d+)*)[._-](.+?)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  pkg "ibm-semeru-open-jdk_#{arch}_mac_#{version.csv.first.tr("+", "_")}_#{version.csv.second}.pkg"

  uninstall pkgutil: "net.ibm-semeru-open.#{version.major}.jdk"

  # No zap stanza required
end