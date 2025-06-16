cask "font-devicons" do
  version "1.8.0"
  sha256 "d8d2dc243ca42897a082ffe32a22cab53cdd148cf87b24162cf450ccfc12fece"

  url "https:github.comvorillazdeviconsarchiverefstags#{version}.tar.gz",
      verified: "github.comvorillazdevicons"
  name "Devicons"
  homepage "https:vorillaz.github.iodevicons"

  no_autobump! because: :requires_manual_review

  font "devicons-#{version}fontsdevicons.ttf"

  # No zap stanza required
end