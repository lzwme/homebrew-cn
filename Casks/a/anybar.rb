cask "anybar" do
  version "0.2.3"
  sha256 "c87dbc6aff5411676a471e84905d69c671b62b93b1210bd95c9d776d087de95c"

  url "https:github.comtonskyAnyBarreleasesdownload#{version}AnyBar-#{version}.zip"
  name "AnyBar"
  desc "Menu bar status indicator"
  homepage "https:github.comtonskyAnyBar"

  no_autobump! because: :requires_manual_review

  app "AnyBar.app"

  # No zap stanza required
end