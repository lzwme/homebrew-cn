cask "font-monocraft" do
  version "4.0"
  sha256 "481ce5fd7d8f40eab5718e1d96a3bcf410f00ab3fefcb63067d5f6e29d8b0c2b"

  url "https://ghfast.top/https://github.com/IdreesInc/Monocraft/releases/download/v#{version}/Monocraft.ttc"
  name "Monocraft"
  homepage "https://github.com/IdreesInc/Monocraft"

  no_autobump! because: :requires_manual_review

  font "Monocraft.ttc"

  # No zap stanza required
end