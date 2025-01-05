cask "ente-auth" do
  version "4.2.3"
  sha256 "ef57143b2225bd44fb567a55bb65f08fb528939846a0bf8e7ac3e9e8bcc9cf5f"

  url "https:github.comente-ioentereleasesdownloadauth-v#{version}ente-auth-v#{version}.dmg",
      verified: "github.comente-ioente"
  name "Ente Auth"
  desc "Desktop client for Ente Auth"
  homepage "https:ente.ioauth"

  livecheck do
    url :url
    regex(^auth[._-]v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  depends_on macos: ">= :mojave"

  app "Ente Auth.app"

  zap trash: [
    "~LibraryApplication Scriptsio.ente.auth.mac",
    "~LibraryContainersio.ente.auth.mac",
  ]
end