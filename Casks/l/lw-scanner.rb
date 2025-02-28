cask "lw-scanner" do
  version "0.27.2"
  sha256 "066429df3a1e40a03126e37418eb39bb3ec38236637499809959c7dd9cb542ab"

  url "https:github.comlaceworklacework-vulnerability-scannerreleasesdownloadv#{version}lw-scanner-darwin-amd64",
      verified: "github.comlaceworklacework-vulnerability-scanner"
  name "Lacework vulnerability scanner"
  desc "Lacework inline scanner"
  homepage "https:docs.lacework.netconsolelocal-scanning-quickstart"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "lw-scanner-darwin-amd64", target: "lw-scanner"

  zap trash: "~.configlw-scanner"

  caveats do
    requires_rosetta
  end
end