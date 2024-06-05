cask "ente-auth" do
  version "3.0.7"
  sha256 "6739792f86670279e8c2ee1496491e2c763da2f1ce644c4c5843a61662096439"

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