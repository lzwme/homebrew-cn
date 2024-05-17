cask "font-sometype-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comdharmatypeSometype-Monoarchivemaster.zip",
      verified: "github.comdharmatypeSometype-Mono"
  name "Sometype Mono"
  homepage "https:monospacedfont.com"

  font "Sometype-Mono-masterfontsotfSometypeMono-Bold.otf"
  font "Sometype-Mono-masterfontsotfSometypeMono-BoldItalic.otf"
  font "Sometype-Mono-masterfontsotfSometypeMono-Medium.otf"
  font "Sometype-Mono-masterfontsotfSometypeMono-MediumItalic.otf"
  font "Sometype-Mono-masterfontsotfSometypeMono-Regular.otf"
  font "Sometype-Mono-masterfontsotfSometypeMono-RegularItalic.otf"

  # No zap stanza required
end