cask "virtualgl" do
  version "3.1.3"
  sha256 "458590566803806e39b9044e4f74cbde7efc0aa712d0598c9a258496914ecec2"

  url "https:github.comVirtualGLvirtualglreleasesdownload#{version}VirtualGL-#{version}.dmg",
      verified: "github.comVirtualGLvirtualgl"
  name "VirtualGL"
  desc "3D without boundaries"
  homepage "https:www.virtualgl.org"

  pkg "VirtualGL.pkg"

  uninstall script:  {
              executable: "optVirtualGLbinuninstall",
              sudo:       true,
            },
            pkgutil: "com.virtualgl.vglclient"
end