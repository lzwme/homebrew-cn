cask "font-udev-gothic-nf" do
  version "1.1.0"
  sha256 "13763a5d7d0cf2a025740b910820933af745a1734baf730c910fad82ffa85178"

  url "https://ghproxy.com/https://github.com/yuru7/udev-gothic/releases/download/v#{version}/UDEVGothic_NF_v#{version}.zip"
  name "UDEV Gothic NF"
  desc "Integrate fonts from BIZ UD Gothic and JetBrains Mono"
  homepage "https://github.com/yuru7/udev-gothic"

  font "UDEVGothic_NF_v#{version}/UDEVGothic35NF-Bold.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NF-BoldItalic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NF-Italic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NF-Regular.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NFLG-Bold.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NFLG-BoldItalic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NFLG-Italic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothic35NFLG-Regular.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNF-Bold.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNF-BoldItalic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNF-Italic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNF-Regular.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNFLG-Bold.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNFLG-BoldItalic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNFLG-Italic.ttf"
  font "UDEVGothic_NF_v#{version}/UDEVGothicNFLG-Regular.ttf"
end