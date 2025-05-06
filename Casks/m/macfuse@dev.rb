cask "macfuse@dev" do
  version "5.0.0"
  sha256 "90342d1a6371babbf481b804b7ef4389459782a14b06e2486ed4694dc9f2889d"

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