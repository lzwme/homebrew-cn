cask "vv" do
  version "2.6.1"
  sha256 "2b0d435fa3d1781289c3a090c4af1d4d0fea82fd8cf4ddafa23eab1a3af07839"

  url "https:github.comvv-vimvvreleasesdownloadv#{version}VV-#{version}-universal.dmg"
  name "VV"
  desc "Neovim client"
  homepage "https:github.comvv-vimvv"

  depends_on formula: "neovim"

  app "VV.app"
  binary "#{appdir}VV.appContentsResourcesbinvv"

  zap trash: "~LibraryApplication SupportVV"
end