cask "zulufx8" do
  arch arm: "aarch64", intel: "x64"
  choice = on_arch_conditional arm: "arm", intel: "x86"

  version "8.0.462,8.88.0.19-ca-fx"
  sha256 arm:   "e190ba6de1e76348c7641555437cf32030fc20005be4015a73f8f30332a2f346",
         intel: "2b1560f3716d743b66531f7ba3dd5a7b5523fe28387b9315f90a133f916d5586"

  url "https://cdn.azul.com/zulu/bin/zulu#{version.csv.second}-jdk#{version.csv.first}-macosx_#{arch}.dmg",
      referer: "https://www.azul.com/downloads/zulu/zulu-mac/"
  name "Azul Zulu Java 8 Standard Edition Development Kit with JavaFX"
  desc "OpenJDK  with JavaFX distribution from Azul"
  homepage "https://www.azul.com/"

  livecheck do
    url "https://api.azul.com/zulu/download/community/v1.0/bundles/latest/?jdk_version=#{version.major}&bundle_type=jdk&javafx=true&ext=dmg&os=macos&arch=#{choice}"
    regex(/zulu(\d+(?:\.\d+)*-.*?)-jdk(\d+(?:\.\d+)+)-macosx_#{arch}\.dmg/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  conflicts_with cask: "zulu8"
  depends_on macos: ">= :mojave"

  pkg "Double-Click to Install Azul Zulu JDK #{version.major}.pkg"

  uninstall pkgutil: "com.azulsystems.zulu.#{version.major}"
end