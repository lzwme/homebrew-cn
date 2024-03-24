cask "vv" do
  version "2.6.0"
  sha256 "2eabec088da81f601979663f86b5271751d42336f2e892dd4532ced433860d92"

  url "https:github.comvv-vimvvreleasesdownloadv#{version}VV-#{version}-universal.dmg"
  name "VV"
  desc "Neovim client"
  homepage "https:github.comvv-vimvv"

  depends_on formula: "neovim"

  app "VV.app"
  binary "#{appdir}VV.appContentsResourcesbinvv"

  zap trash: "~LibraryApplication SupportVV"
end