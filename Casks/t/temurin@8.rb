cask "temurin@8" do
  version "8,422,05.1"
  sha256 "809d7c0b6c7c2fd483711fb784e4fb101ad431c71dc8e96aa9c2cffaa8bfa7b7"

  url "https:github.comadoptiumtemurin8-binariesreleasesdownloadjdk#{version.csv.first}u#{version.csv.second}-b#{version.csv.third}OpenJDK#{version.csv.first}U-jdk_x64_mac_hotspot_#{version.csv.first}u#{version.csv.second}b#{version.csv.third.split(".").first}.pkg",
      verified: "github.comadoptiumtemurin8-binaries"
  name "Eclipse Temurin 8"
  desc "JDK from the Eclipse Foundation (Adoptium)"
  homepage "https:adoptium.net"

  livecheck do
    url "https:api.adoptium.netv3assetsfeature_releases8ga?architecture=x64&image_type=jdk&jvm_impl=hotspot&os=mac&page=0&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse"
    regex(^jdk(\d+)u(\d+)-b(\d+(?:\.\d+)*)$i)
    strategy :json do |json, regex|
      json.map do |release|
        match = release["release_name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]},#{match[3]}"
      end
    end
  end

  pkg "OpenJDK#{version.csv.first}U-jdk_x64_mac_hotspot_#{version.csv.first}u#{version.csv.second}b#{version.csv.third.split(".").first}.pkg"

  uninstall pkgutil: "net.temurin.#{version.csv.first}.jdk"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end