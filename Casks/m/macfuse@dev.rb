cask "macfuse@dev" do
  version "4.10.0"
  sha256 "6a532aa102325efdb727fd85ed677b6d07c652d88398f031acaf0cfc3b359645"

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