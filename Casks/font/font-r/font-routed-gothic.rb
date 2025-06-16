cask "font-routed-gothic" do
  version "1.0.0"
  sha256 "e0079b81fa068a4672f02585f7bc2910bf1535d8cd73b04d4a023bd2cbca361d"

  url "https:github.comdserouted-gothicarchiverefstagsv#{version}.tar.gz",
      verified: "github.comdserouted-gothic"
  name "Routed Gothic"
  homepage "https:webonastick.comfontsrouted-gothic"

  no_autobump! because: :requires_manual_review

  font "routed-gothic-#{version}distttfrouted-gothic-half-italic.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-italic.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-narrow-half-italic.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-narrow-italic.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-narrow.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-wide-half-italic.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-wide-italic.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic-wide.ttf"
  font "routed-gothic-#{version}distttfrouted-gothic.ttf"

  # No zap stanza required
end