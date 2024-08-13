cask "ente-auth" do
  version "3.1.1"
  sha256 "10d166e1467d5f7f8d0f1048c98556442f2f86e876b009e661c28ec86f8878c1"

  url "https:github.comente-ioentereleasesdownloadauth-v#{version}ente-auth-v#{version}.dmg",
      verified: "github.comente-ioente"
  name "Ente Auth"
  desc "Desktop client for Ente Auth"
  homepage "https:ente.io"

  livecheck do
    url :url
    regex(^auth[._-]v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Ente Auth.app"

  zap trash: [
    "~LibraryApplication Scriptsio.ente.auth.mac",
    "~LibraryContainersio.ente.auth.mac",
  ]
end