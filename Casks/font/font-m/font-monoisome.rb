cask "font-monoisome" do
  version "0.61"
  sha256 :no_check

  url "https:github.comlarsenworkmonoidblobmasterMonoisomeMonoisome-Regular.ttf?raw=true",
      verified: "github.comlarsenworkmonoid"
  name "Monoisome"
  homepage "https:larsenwork.commonoid"

  livecheck do
    url :url
  end

  font "Monoisome-Regular.ttf"

  # No zap stanza required
end