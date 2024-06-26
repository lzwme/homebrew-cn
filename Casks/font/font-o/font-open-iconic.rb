cask "font-open-iconic" do
  version "1.1.1"
  sha256 "846dafa3d3aebef38bcc9b5d7b7613846dbc07f5f06536b42ac682976524b6c4"

  url "https:github.comiconicopen-iconicarchiverefstags#{version}.tar.gz"
  name "Open Iconic"
  homepage "https:github.comiconicopen-iconic"

  font "open-iconic-#{version}fontfontsopen-iconic.ttf"

  # No zap stanza required
end