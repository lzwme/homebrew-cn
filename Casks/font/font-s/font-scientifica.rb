cask "font-scientifica" do
  version "2.3"
  sha256 "f0857869a0e846c6f175dcb853dd1f119ea17a75218e63b7f0736d5a8e1e8a7f"

  url "https:github.comoppiliappanscientificareleasesdownloadv#{version}scientifica.tar"
  name "Scientifica"
  homepage "https:github.comoppiliappanscientifica"

  no_autobump! because: :requires_manual_review

  font "scientificattfscientifica.ttf"
  font "scientificattfscientificaBold.ttf"
  font "scientificattfscientificaItalic.ttf"

  # No zap stanza required
end