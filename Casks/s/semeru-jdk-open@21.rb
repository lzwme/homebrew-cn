cask "semeru-jdk-open@21" do
  arch arm: "aarch64", intel: "x64"

  version "21.0.2+13,openj9-0.43.0"
  sha256 arm:   "569ec5928e834240ab8b2655c7d80100335808cd364e343457489bbea124890a",
         intel: "7540948635e1c275476cc5e0a2a72c7303852cea84419750733af63e76539f0a"

  url "https:github.comibmruntimessemeru#{version.major}-binariesreleasesdownloadjdk-#{version.csv.first}_#{version.csv.second}ibm-semeru-open-jdk_#{arch}_mac_#{version.csv.first.tr("+", "_")}_#{version.csv.second}.pkg",
      verified: "github.comibmruntimessemeru#{version.major}-binaries"
  name "IBM Semeru Runtime (JDK 21) Open Edition"
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