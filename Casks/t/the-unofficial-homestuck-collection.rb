cask "the-unofficial-homestuck-collection" do
  version "2.6.7"
  sha256 "c0fbf73b03c6e4c9fd8c0e3bc0f6bc3d6ddb9729c53f04c9c9a5921c88ee3ac5"

  url "https://ghfast.top/https://github.com/Bambosh/unofficial-homestuck-collection/releases/download/v#{version}/The-Unofficial-Homestuck-Collection-#{version}.dmg",
      verified: "github.com/Bambosh/unofficial-homestuck-collection/"
  name "The Unofficial Homestuck Collection"
  desc "Offline viewer for the webcomic Homestuck"
  homepage "https://bambosh.github.io/unofficial-homestuck-collection/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "The Unofficial Homestuck Collection.app"

  zap trash: [
    "~/Library/Application Support/unofficial-homestuck-collection",
    "~/Library/Preferences/com.bambosh.unofficialhomestuckcollection.plist",
    "~/Library/Saved Application State/com.bambosh.unofficialhomestuckcollection.savedState",
  ]

  caveats do
    requires_rosetta
    <<~EOS
      You will need to download the corresponding Asset Pack by visiting:
        https://bambosh.github.io/unofficial-homestuck-collection/
    EOS
  end
end