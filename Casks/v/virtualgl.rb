cask "virtualgl" do
  version "3.1.1"
  sha256 "9d97cc927767199e37a646393d8e81138e9375f15c8c2aac3c5060a774db6420"

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