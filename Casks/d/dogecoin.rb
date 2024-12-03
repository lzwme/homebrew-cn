cask "dogecoin" do
  version "1.14.9"
  sha256 "c87c956834a87da8200274a097364c986ccca045d71ce92d0f7d407129d25a83"

  url "https:github.comdogecoindogecoinreleasesdownloadv#{version}dogecoin-#{version}-osx-unsigned.dmg",
      verified: "github.comdogecoindogecoin"
  name "Dogecoin"
  desc "Cryptocurrency"
  homepage "https:dogecoin.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Dogecoin-Qt.app"

  preflight do
    set_permissions "#{staged_path}Dogecoin-Qt.app", "0755"
  end

  zap trash: "~Librarycom.dogecoin.Dogecoin-Qt.plist"

  caveats do
    requires_rosetta
  end
end