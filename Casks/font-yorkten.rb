require_relative "..libb2_download_strategy" unless defined?(B2DownloadStrategy)

cask "font-yorkten" do
  version "1.0"
  sha256 "81f982760c588afb871ff2c340eac4f812aed056aa93a38882efb5fe0aad83a5"

  url "b2:backblazeb2.combreweryfontsyorkten.zip",
      verified: "backblazeb2.combrewery"
  name "Yorkten"
  desc "Yorkten font family"
  homepage "https:github.comcodellohomebrew-brewery"

  font "Yorkten-ConBla.ttf"
  font "Yorkten-ConBlaIt.ttf"
  font "Yorkten-ConBol.ttf"
  font "Yorkten-ConBolIt.ttf"
  font "Yorkten-ConBoo.ttf"
  font "Yorkten-ConBooIt.ttf"
  font "Yorkten-ConDem.ttf"
  font "Yorkten-ConDemIt.ttf"
  font "Yorkten-ConExB.ttf"
  font "Yorkten-ConExBIt.ttf"
  font "Yorkten-ConLig.ttf"
  font "Yorkten-ConLigIt.ttf"
  font "Yorkten-ConMed.ttf"
  font "Yorkten-ConMedIt.ttf"
  font "Yorkten-ConReg.ttf"
  font "Yorkten-ConRegIt.ttf"
  font "Yorkten-ConThi.ttf"
  font "Yorkten-ConThiIt.ttf"
  font "Yorkten-ExtBla.ttf"
  font "Yorkten-ExtBlaIt.ttf"
  font "Yorkten-ExtBol.ttf"
  font "Yorkten-ExtBolIt.ttf"
  font "Yorkten-ExtBoo.ttf"
  font "Yorkten-ExtBooIt.ttf"
  font "Yorkten-ExtDem.ttf"
  font "Yorkten-ExtDemIt.ttf"
  font "Yorkten-ExtExB.ttf"
  font "Yorkten-ExtExBIt.ttf"
  font "Yorkten-ExtLig.ttf"
  font "Yorkten-ExtLigIt.ttf"
  font "Yorkten-ExtMed.ttf"
  font "Yorkten-ExtMedIt.ttf"
  font "Yorkten-ExtReg.ttf"
  font "Yorkten-ExtRegIt.ttf"
  font "Yorkten-ExtThi.ttf"
  font "Yorkten-ExtThiIt.ttf"
  font "Yorkten-NorBla.ttf"
  font "Yorkten-NorBlaIt.ttf"
  font "Yorkten-NorBol.ttf"
  font "Yorkten-NorBolIt.ttf"
  font "Yorkten-NorBoo.ttf"
  font "Yorkten-NorBooIt.ttf"
  font "Yorkten-NorDem.ttf"
  font "Yorkten-NorDemIt.ttf"
  font "Yorkten-NorExB.ttf"
  font "Yorkten-NorExBIt.ttf"
  font "Yorkten-NorLig.ttf"
  font "Yorkten-NorLigIt.ttf"
  font "Yorkten-NorMed.ttf"
  font "Yorkten-NorMedIt.ttf"
  font "Yorkten-NorReg.ttf"
  font "Yorkten-NorRegIt.ttf"
  font "Yorkten-NorThi.ttf"
  font "Yorkten-NorThiIt.ttf"
end