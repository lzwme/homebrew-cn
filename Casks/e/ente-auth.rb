cask "ente-auth" do
  version "4.2.4"
  sha256 "b3be236d72bbe9b4b47a1362082175c423e8087f80365189ffa5719901e09670"

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