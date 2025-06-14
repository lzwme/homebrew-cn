cask "athens" do
  arch arm: "-arm64"

  version "2.0.0"
  sha256 arm:   "1d1c289feb1e0182dbace1d5ff9d71107a2f76b20a3327ff82a4887a832637b6",
         intel: "50596cfd8dcdc6502efe30e818429dc7cf109f5968fc30d14d26669ce0f53971"

  url "https:github.comathensresearchathensreleasesdownloadv#{version}Athens-#{version}#{arch}.dmg",
      verified: "github.comathensresearchathens"
  name "Athens"
  desc "Self-hosted knowledge graph"
  homepage "https:web.archive.orgweb20230709013630https:www.athensresearch.org"

  no_autobump! because: :requires_manual_review

  # https:github.comathensresearchathenscommit73ccd7b4b65f5dca8e842153bb9e39efd0d371be
  deprecate! date: "2024-01-15", because: :unmaintained
  disable! date: "2025-01-15", because: :unmaintained

  app "Athens.app"

  zap trash: [
    "~Documentsathens",
    "~LibraryApplication SupportAthens",
    "~LibraryLogsAthens",
    "~LibraryPreferencescom.athensresearch.athens.plist",
    "~LibrarySaved Application Statecom.athensresearch.athens.savedState",
  ]
end