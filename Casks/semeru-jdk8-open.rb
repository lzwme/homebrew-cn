cask "semeru-jdk8-open" do
  version "8u392-b08,openj9-0.41.0"
  sha256 "1bb9a13fe2c09fd1871acbaf8a36450ab6f4f5409d849243e932c1d7188b5472"

  url "https:github.comibmruntimessemeru8-binariesreleasesdownloadjdk#{version.csv.first}_#{version.csv.second}ibm-semeru-open-jdk_x64_mac_#{version.csv.first.tr("-", "")}_#{version.csv.second}.pkg",
      verified: "github.comibmruntimessemeru8-binaries"
  name "IBM Semeru Runtime (JDK 8) Open Edition"
  desc "Production-ready JDK with the OpenJDK class libraries and the Eclipse OpenJ9 JVM"
  homepage "https:developer.ibm.comlanguagesjavasemeru-runtimes"

  livecheck do
    url :stable
    regex(^(?:jdk)?(\d+u\d+)[._-](b\d+)[._-](.+?)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]}-#{match[1]},#{match[2]}" }
    end
  end

  pkg "ibm-semeru-open-jdk_x64_mac_#{version.csv.first.tr("-", "")}_#{version.csv.second}.pkg"

  uninstall pkgutil: "net.ibm-semeru-open.8.jdk"

  # No zap stanza required
end