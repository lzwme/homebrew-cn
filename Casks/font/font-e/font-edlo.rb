cask "font-edlo" do
  version :latest
  sha256 :no_check

  url "https:github.comehamiterEdloarchiverefsheadsmaster.tar.gz",
      verified: "github.comehamiterEdlo"
  name "Edlo"
  homepage "https:ehamiter.github.ioEdlo"

  font "Edlo-masteredlo.ttf"
  font "Edlo-masteredlo-nerd-font.ttf"

  # No zap stanza required
end