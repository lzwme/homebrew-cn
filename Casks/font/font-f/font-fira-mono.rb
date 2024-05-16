cask "font-fira-mono" do
  version "3.206,4.202"
  sha256 "d86269657387f144d77ba12011124f30f423f70672e1576dc16f918bb16ddfe4"

  url "https:github.commozillaFiraarchive#{version.csv.second}.tar.gz",
      verified: "github.commozillaFira"
  name "Fira Mono"
  homepage "https:mozilla.github.ioFira"

  font "Fira-#{version.after_comma}otfFiraMono-Bold.otf"
  font "Fira-#{version.after_comma}otfFiraMono-Medium.otf"
  font "Fira-#{version.after_comma}otfFiraMono-Regular.otf"

  # No zap stanza required
end