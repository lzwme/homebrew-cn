cask "temurin21" do
  arch arm: "aarch64", intel: "x64"

  version "21.0.2,13"
  sha256 arm:   "fcae8adc4386604d25866f8100f6cd5d232a6befc775554382040e91d8a201c8",
         intel: "2982a6aa0f90df991534a88ee3c9858708ebf5681a1310df77df582da8a77908"

  url "https:github.comadoptiumtemurin#{version.major}-binariesreleasesdownloadjdk-#{version.csv.first}%2B#{version.csv.second}OpenJDK#{version.major}U-jdk_#{arch}_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg",
      verified: "github.comadoptium"
  name "Eclipse Temurin 21"
  desc "JDK from the Eclipse Foundation (Adoptium)"
  homepage "https:adoptium.net"

  livecheck do
    url "https:api.adoptium.netv3assetsfeature_releases#{version.major}ga?architecture=#{arch}&image_type=jdk&jvm_impl=hotspot&os=mac&page=0&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse"
    regex(^jdk-(\d+(?:\.\d+)*?)\+(\d+(?:\.\d+)*)(?:-LTS)?$i)
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