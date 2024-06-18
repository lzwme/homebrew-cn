cask "ente-auth" do
  version "3.0.12"
  sha256 "06b1cb471e83dfb785615c77f5a7b794ed19699ef89b6ef60247317adeeb30f5"

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