cask "macfuse@dev" do
  version "4.10.2"
  sha256 "fcca8ec48742288dccdd36db65bb92c4fe4bc23c2c7c5b76aa0ac68e06aebe88"

  url "https:github.commacfusemacfusereleasesdownloadmacfuse-#{version}macfuse-#{version}.dmg",
      verified: "github.commacfusemacfuse"
  name "macFUSE"
  desc "File system integration"
  homepage "https:macfuse.github.io"

  livecheck do
    url "https:macfuse.github.ioreleasesDeveloperRelease.plist"
    strategy :xml do |xml|
      xml.get_elements("key[text()='Version']").map { |item| item.next_element&.text&.strip }
    end
  end

  auto_updates true
  conflicts_with cask: "macfuse"
  depends_on macos: ">= :sierra"

  pkg "ExtrasmacFUSE #{version}.pkg"

  postflight do
    set_ownership ["usrlocalinclude", "usrlocallib"]
  end

  uninstall pkgutil: [
    "io.macfuse.installer.components.core",
    "io.macfuse.installer.components.preferencepane",
  ]

  zap trash: "LibraryPreferencePanesmacFUSE.prefPane"

  caveats do
    kext
  end
end