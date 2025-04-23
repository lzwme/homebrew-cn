cask "adoptopenjdk" do
  version "16.0.1,9"
  sha256 "7308a15d054d07d504f616416b3622d153c3cc63906441a5730ca1f9d4a43854"

  url "https:github.comAdoptOpenJDKopenjdk#{version.major}-binariesreleasesdownloadjdk-#{version.csv.first}%2B#{version.csv.second}OpenJDK#{version.major}U-jdk_x64_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg",
      verified: "github.comAdoptOpenJDK"
  name "AdoptOpenJDK Java Development Kit"
  desc "JDK from the Java User Group (JUG)"
  homepage "https:adoptopenjdk.net"

  disable! date: "2024-12-16", because: :discontinued, replacement_cask: "temurin"

  pkg "OpenJDK#{version.major}U-jdk_x64_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg"

  uninstall pkgutil: "net.adoptopenjdk.#{version.major}.jdk"

  zap trash: [
    "~LibrarySaved Application Statenet.java.openjdk.*.java.savedState",
    "~LibrarySaved Application Statenet.java.openjdk.cmd.savedState",
    "~LibrarySaved Application Statenet.java.openjdk.java.savedState",
  ]

  caveats do
    requires_rosetta
  end
end