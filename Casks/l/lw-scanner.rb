cask "lw-scanner" do
  version "0.25.0"
  sha256 "b8bbe30c59561bd189b9090a0b95cdc06db7beef7bc9f9de47f347106a371a16"

  url "https:github.comlaceworklacework-vulnerability-scannerreleasesdownload#{version}lw-scanner-darwin-amd64",
      verified: "github.comlaceworklacework-vulnerability-scanner"
  name "Lacework vulnerability scanner"
  desc "Lacework inline scanner"
  homepage "https:docs.lacework.netconsolelocal-scanning-quickstart"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "lw-scanner-darwin_amd64", target: "lw-scanner"

  zap trash: "~.configlw-scanner"

  caveats do
    requires_rosetta
  end
end