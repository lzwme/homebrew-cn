cask "adoptopenjdk8" do
  version "8,292,b10"
  sha256 "4e200bc752337abc9dbfddf125db6a600f2ec53566f6f119a83036c8242a7672"

  url "https:github.comAdoptOpenJDKopenjdk8-binariesreleasesdownloadjdk#{version.csv.first}u#{version.csv.second}-#{version.csv.third}OpenJDK#{version.csv.first}U-jdk_x64_mac_hotspot_#{version.csv.first}u#{version.csv.second}#{version.csv.third}.pkg",
      verified: "github.comAdoptOpenJDKopenjdk8-binaries"
  name "AdoptOpenJDK 8"
  desc "Prebuilt OpenJDK binaries"
  homepage "https:adoptopenjdk.net"

  deprecate! date: "2023-12-17", because: :discontinued

  pkg "OpenJDK#{version.csv.first}U-jdk_x64_mac_hotspot_#{version.csv.first}u#{version.csv.second}#{version.csv.third}.pkg"

  uninstall pkgutil: "net.adoptopenjdk.#{version.csv.first}.jdk"

  # No zap stanza required

  caveats do
    <<~EOS
      Temurin is the official successor to this software:

        brew install --cask temurin8
    EOS
  end
end