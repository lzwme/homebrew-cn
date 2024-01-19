cask "temurin17" do
  arch arm: "aarch64", intel: "x64"

  version "17.0.10,7"
  sha256 arm:   "a6db8e5519f113ded7c30b02d7fc86610abe2050d8c110ab6a619f1bb647ecb8",
         intel: "f4cd8b6c187148ebfe7bc256a51e3eff98c271c242a152d5b5247efbbc83ca0f"

  url "https:github.comadoptiumtemurin#{version.major}-binariesreleasesdownloadjdk-#{version.csv.first}%2B#{version.csv.second}OpenJDK#{version.major}U-jdk_#{arch}_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg",
      verified: "github.comadoptium"
  name "Eclipse Temurin Java Development Kit"
  desc "JDK from the Eclipse Foundation (Adoptium)"
  homepage "https:adoptium.net"

  livecheck do
    url "https:api.adoptium.netv3assetsfeature_releases#{version.major}ga?architecture=#{arch}&image_type=jdk&jvm_impl=hotspot&os=mac&page=0&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse"
    regex(^jdk-(\d+(?:\.\d+)+)\+(\d+(?:\.\d+)*)$i)
    strategy :json do |json, regex|
      json.map do |release|
        match = release["release_name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  pkg "OpenJDK#{version.major}U-jdk_#{arch}_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg"

  uninstall pkgutil: "net.temurin.#{version.major}.jdk"

  # No zap stanza required
end