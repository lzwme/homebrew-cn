cask "font-agave" do
  version "37"
  sha256 "12af3b8cb7d645f7aa60b8680d1eae95f409affef921aac15ff3e05906e9e9d3"

  url "https:github.comblobjectagavearchiverefstagsv#{version}.tar.gz",
      verified: "github.comblobjectagave"
  name "Agave"
  homepage "https:b.agaric.netpageagave"

  no_autobump! because: :requires_manual_review

  font "agave-#{version}distAgave-Bold.ttf"
  font "agave-#{version}distAgave-Regular.ttf"

  # No zap stanza required
end