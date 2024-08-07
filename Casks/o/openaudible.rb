cask "openaudible" do
  version "4.4.2"
  sha256 "07c1aaca479f286f553d1da12d3bf0544837419157c0779ede24d908d4b91e74"

  url "https:github.comopenaudibleopenaudiblereleasesdownloadv#{version}OpenAudible_#{version}.dmg",
      verified: "github.comopenaudibleopenaudible"
  name "OpenAudible"
  desc "Audiobook manager for Audible users"
  homepage "https:openaudible.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "OpenAudible.app"

  zap trash: "LibraryOpenAudible"
end