cask "x-moto" do
  version "0.6.2"
  sha256 "40818cff5020b8b962f680ef7f99f6cce26b3ff1da6775bba39313461df62d44"

  url "https:github.comxmotoxmotoreleasesdownloadv#{version}xmoto-#{version}-macos.dmg",
      verified: "github.comxmotoxmoto"
  name "X-Moto"
  desc "2D motocross platform game"
  homepage "https:xmoto.tuxfamily.org"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  app "X-Moto.app"

  zap trash: "~LibrarySaved Application Statenet.sourceforge.xmoto.savedState"

  caveats do
    requires_rosetta
  end
end