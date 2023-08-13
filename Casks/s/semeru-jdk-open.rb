cask "semeru-jdk-open" do
  arch arm: "aarch64", intel: "x64"

  version "20.0.2+9,openj9-0.40.0"
  sha256 arm:   "d647374134635b686e91769eb5c1df657a4031bd11f1012084d8bbb23ae202d6",
         intel: "d736f77e208fb53f19d8a1791ec2d1e749a387659a5c1c85fce45d1efe83d66f"

  url "https://ghproxy.com/https://github.com/ibmruntimes/semeru#{version.major}-binaries/releases/download/jdk-#{version.csv.first}_#{version.csv.second}/ibm-semeru-open-jdk_#{arch}_mac_#{version.csv.first.tr("+", "_")}_#{version.csv.second}.pkg",
      verified: "github.com/ibmruntimes/"
  name "IBM Semeru Runtime (JDK) Open Edition"
  desc "Production-ready JDK with the OpenJDK class libraries and the Eclipse OpenJ9 JVM"
  homepage "https://developer.ibm.com/languages/java/semeru-runtimes"

  livecheck do
    url :stable
    regex(/^jdk[._-](\d+(?:[.+]\d+)*)[._-](.+?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  pkg "ibm-semeru-open-jdk_#{arch}_mac_#{version.csv.first.tr("+", "_")}_#{version.csv.second}.pkg"

  uninstall pkgutil: "net.ibm-semeru-open.#{version.major}.jdk"

  # No zap stanza required
end