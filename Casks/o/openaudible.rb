cask "openaudible" do
  version "4.4.8"
  sha256 "20066c545cce4e0afd27a039ca41755f3d7aac4d7abaed44cb70d3eadae0c20e"

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