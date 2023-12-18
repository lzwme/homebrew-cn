cask "temurin11" do
  arch arm: "aarch64", intel: "x64"

  version "11.0.21,9"
  sha256 arm:   "bda5ff55eb0eef122af974b970fa178213d9d7093fe5994f3daf08d5a97f2401",
         intel: "5ed977f0aecd4461d8b14b347e6a418bb61ee4cbe6f8f99f17a43d5a4e115980"

  url "https:github.comadoptiumtemurin#{version.major}-binariesreleasesdownloadjdk-#{version.csv.first}%2B#{version.csv.second}OpenJDK#{version.major}U-jdk_#{arch}_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg",
      verified: "github.comadoptium"
  name "Eclipse Temurin 11"
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