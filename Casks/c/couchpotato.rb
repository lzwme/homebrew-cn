cask "couchpotato" do
  version "3.0.1"
  sha256 "b1db35f93727fc30e50f4d2023b7d844db5a725d16fd6072e3d10b805c2d7e28"

  url "https://ghfast.top/https://github.com/CouchPotato/CouchPotatoServer/releases/download/build%2F#{version}/CouchPotato-#{version}.macosx-10_6-intel.zip",
      verified: "github.com/CouchPotato/CouchPotatoServer/"
  name "CouchPotato"
  desc "Automatic Movie Downloading via NZBs & Torrents"
  homepage "https://couchpota.to/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "CouchPotato.app"

  zap trash: "~/Library/Application Support/CouchPotato"

  caveats do
    requires_rosetta
  end
end