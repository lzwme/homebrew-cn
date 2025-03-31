cask "openaudible" do
  version "4.5.3"
  sha256 "007afbb8ec323e1597f109b45f59ff7866cfe4c61c09ee3ec12150c8f911f70f"

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