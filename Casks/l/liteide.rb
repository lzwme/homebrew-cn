cask "liteide" do
  version "38.3"
  sha256 "eee15c537100c48e2d28a35a8df047e3d4d7e8551a0e57d81af834cfea2a8e45"

  url "https:github.comvisualfcliteidereleasesdownloadx#{version}liteidex#{version}.macos-qt5.15.2.zip"
  name "LiteIDE"
  desc "Go IDE"
  homepage "https:github.comvisualfcliteide"

  livecheck do
    url :url
    regex((?:x[._\s-]?)(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "liteideLiteIDE.app"

  # No zap stanza required
end