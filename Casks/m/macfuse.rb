cask "macfuse" do
  version "4.10.1"
  sha256 "a523fcc910534ce7d8c616c5eef2e5026ee36440510df4bdd9477c44744ae6bf"

  url "https:github.commacfusemacfusereleasesdownloadmacfuse-#{version}macfuse-#{version}.dmg",
      verified: "github.commacfusemacfuse"
  name "macFUSE"
  desc "File system integration"
  homepage "https:macfuse.github.io"

  livecheck do
    url "https:macfuse.github.ioreleasesCurrentRelease.plist"
    strategy :xml do |xml|
      xml.get_elements("key[text()='Version']").map { |item| item.next_element&.text&.strip }
    end
  end

  auto_updates true
  conflicts_with cask: "macfuse@dev"
  depends_on macos: ">= :sierra"

  pkg "ExtrasmacFUSE #{version}.pkg"

  postflight do
    set_ownership ["usrlocalinclude", "usrlocallib"]
  end

  uninstall pkgutil: [
    "io.macfuse.installer.components.core",
    "io.macfuse.installer.components.preferencepane",
  ]

  zap trash: [
    "LibraryPreferencePanesmacFUSE.prefPane",
    "~LibraryCachesio.macfuse.preferencepanes.macfuse",
    "~LibraryHTTPStoragesio.macfuse.preferencepanes.macfuse",
  ]

  caveats do
    kext
  end
end