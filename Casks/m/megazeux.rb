cask "megazeux" do
  version "2.93"
  sha256 :no_check

  url "https:www.digitalmzx.comdownload.php?latest=osx"
  name "MegaZeux"
  desc "ASCII-based game creation system"
  homepage "https:www.digitalmzx.com"

  livecheck do
    url "https:github.comAliceLRmegazeux"
    strategy :git
  end

  app "MegaZeux.app"
  artifact "Documentation", target: "~LibraryApplication SupportMegaZeuxDocumentation"

  zap trash: [
    "~.megazeux-config",
    "~LibraryApplication SupportMegaZeux",
  ]
end