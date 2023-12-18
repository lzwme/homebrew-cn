cask "brooklyn" do
  version "2.1.0"
  sha256 "6f14527303a8d55384a38368e7fe1909c52c04cc1ce2fbd149d9712b8ab68ee6"

  url "https:github.compedrommcarrascoBrooklynreleasesdownload#{version}Brooklyn.saver.zip"
  name "Brooklyn"
  desc "Screen saver based on animations presented during Apple Special Event Brooklyn"
  homepage "https:github.compedrommcarrascoBrooklyn"

  screen_saver "Brooklyn.saver"

  zap trash: "~LibraryScreen SaversBrooklyn.saver"
end