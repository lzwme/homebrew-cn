cask "liteide" do
  version "38.4"
  sha256 "f1c650216d6280e705ae76a99de1421e567840719c2d35d45b9f3aa9c037cae7"

  url "https:github.comvisualfcliteidereleasesdownloadx#{version}liteidex#{version}-macos-qt5.15.16.zip"
  name "LiteIDE"
  desc "Go IDE"
  homepage "https:github.comvisualfcliteide"

  livecheck do
    url :url
    regex((?:x[._\s-]?)(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "liteideLiteIDE.app"

  # No zap stanza required
  caveats do
    requires_rosetta
  end
end