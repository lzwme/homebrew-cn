cask "vv" do
  version "2.4.10"
  sha256 "b6060d1105745640728fd7cdcc6a312a1d497a29cb30e5575cfb3318cd9577e8"

  url "https:github.comvv-vimvvreleasesdownloadv#{version}VV-#{version}.dmg"
  name "VV"
  desc "Neovim client"
  homepage "https:github.comvv-vimvv"

  depends_on formula: "neovim"

  app "VV.app"
  binary "#{appdir}VV.appContentsResourcesbinvv"

  zap trash: "~LibraryApplication SupportVV"
end