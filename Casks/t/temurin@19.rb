cask "temurin@19" do
  arch arm: "aarch64", intel: "x64"

  version "19.0.2,7"
  sha256 arm:   "cf740487eb79e5a4c7bc85a1a79b0bb71e58e30a7124b26506babf5aa8871224",
         intel: "60d33104b758c92a4b8560ff0517c7fd91820c26a1f7ee1710a3dc8949795ad3"

  url "https:github.comadoptiumtemurin19-binariesreleasesdownloadjdk-#{version.csv.first}%2B#{version.csv.second}OpenJDK19U-jdk_#{arch}_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg",
      verified: "github.comadoptium"
  name "Eclipse Temurin Java Development Kit"
  desc "JDK from the Eclipse Foundation (Adoptium)"
  homepage "https:adoptium.net"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-21", because: :discontinued

  pkg "OpenJDK19U-jdk_#{arch}_mac_hotspot_#{version.csv.first}_#{version.csv.second.major}.pkg"

  uninstall pkgutil: "net.temurin.19.jdk"

  # No zap stanza required
end