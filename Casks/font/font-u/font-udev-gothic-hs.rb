cask "font-udev-gothic-hs" do
  version "2.1.0"
  sha256 "25e6730e929194b15d788aa9a67f0b8285214904a693c753ecbb020da54abe0f"

  url "https:github.comyuru7udev-gothicreleasesdownloadv#{version}UDEVGothic_HS_v#{version}.zip"
  name "UDEV Gothic HS"
  homepage "https:github.comyuru7udev-gothic"

  no_autobump! because: :requires_manual_review

  font "UDEVGothic_HS_v#{version}UDEVGothic35HS-Bold.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HS-BoldItalic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HS-Italic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HS-Regular.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSJPDOC-Bold.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSJPDOC-BoldItalic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSJPDOC-Italic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSJPDOC-Regular.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSLG-Bold.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSLG-BoldItalic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSLG-Italic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothic35HSLG-Regular.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHS-Bold.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHS-BoldItalic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHS-Italic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHS-Regular.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSJPDOC-Bold.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSJPDOC-BoldItalic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSJPDOC-Italic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSJPDOC-Regular.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSLG-Bold.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSLG-BoldItalic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSLG-Italic.ttf"
  font "UDEVGothic_HS_v#{version}UDEVGothicHSLG-Regular.ttf"

  # No zap stanza required
end