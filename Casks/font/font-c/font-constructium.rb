cask "font-constructium" do
  version "2024-06-01"
  sha256 "85cf9d728b143169ddf4f9c00a53025dce533a748646d1d7afbe24c18d6dbe2e"

  url "https:github.comkreativekorpopen-relayreleasesdownload#{version}Constructium.zip",
      verified: "github.comkreativekorpopen-relay"
  name "Constructium"
  homepage "https:www.kreativekorp.comsoftwarefontsconstructium"

  font "Constructium.ttf"

  # No zap stanza required
end