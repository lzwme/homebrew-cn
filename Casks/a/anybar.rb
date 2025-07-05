cask "anybar" do
  version "0.2.3"
  sha256 "c87dbc6aff5411676a471e84905d69c671b62b93b1210bd95c9d776d087de95c"

  url "https://ghfast.top/https://github.com/tonsky/AnyBar/releases/download/#{version}/AnyBar-#{version}.zip"
  name "AnyBar"
  desc "Menu bar status indicator"
  homepage "https://github.com/tonsky/AnyBar"

  no_autobump! because: :requires_manual_review

  app "AnyBar.app"

  # No zap stanza required
end