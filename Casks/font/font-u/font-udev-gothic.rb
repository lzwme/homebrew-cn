cask "font-udev-gothic" do
  version "2.1.0"
  sha256 "69c9321d3bac85589ddfee730e9582e3a9ca664d84d520fa7a70f656f1a0b8e5"

  url "https:github.comyuru7udev-gothicreleasesdownloadv#{version}UDEVGothic_v#{version}.zip"
  name "UDEV Gothic"
  homepage "https:github.comyuru7udev-gothic"

  no_autobump! because: :requires_manual_review

  font "UDEVGothic_v#{version}UDEVGothic-Bold.ttf"
  font "UDEVGothic_v#{version}UDEVGothic-BoldItalic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic-Italic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic-Regular.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35-Bold.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35-BoldItalic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35-Italic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35-Regular.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35JPDOC-Bold.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35JPDOC-BoldItalic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35JPDOC-Italic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35JPDOC-Regular.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35LG-Bold.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35LG-BoldItalic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35LG-Italic.ttf"
  font "UDEVGothic_v#{version}UDEVGothic35LG-Regular.ttf"
  font "UDEVGothic_v#{version}UDEVGothicJPDOC-Bold.ttf"
  font "UDEVGothic_v#{version}UDEVGothicJPDOC-BoldItalic.ttf"
  font "UDEVGothic_v#{version}UDEVGothicJPDOC-Italic.ttf"
  font "UDEVGothic_v#{version}UDEVGothicJPDOC-Regular.ttf"
  font "UDEVGothic_v#{version}UDEVGothicLG-Bold.ttf"
  font "UDEVGothic_v#{version}UDEVGothicLG-BoldItalic.ttf"
  font "UDEVGothic_v#{version}UDEVGothicLG-Italic.ttf"
  font "UDEVGothic_v#{version}UDEVGothicLG-Regular.ttf"

  # No zap stanza required
end