cask "openaudible" do
  version "4.5.1"
  sha256 "f703bbb7536dc9412279ba6eb79d8df3e5214cfb8a7fa5d981c040c50193e6bb"

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