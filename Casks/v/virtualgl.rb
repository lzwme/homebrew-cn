cask "virtualgl" do
  version "3.1.2"
  sha256 "6ab290b393136a3845b3f0140f8cd76d95d5e5910aa9a9546443f6ded2054e71"

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