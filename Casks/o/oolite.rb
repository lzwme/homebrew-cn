cask "oolite" do
  version "1.90"
  sha256 "0f3ee04e6874b560482c091445a73d1411a444538928e232681d15a829fab605"

  url "https:github.comOoliteProjectoolitereleasesdownload#{version}Oolite-#{version}.zip",
      verified: "github.comOoliteProjectoolite"
  name "oolite"
  desc "Space trading and combat simulator"
  homepage "https:www.oolite.space"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-27", because: :discontinued

  app "Oolite.app"

  caveats do
    requires_rosetta
  end
end