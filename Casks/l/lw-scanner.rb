cask "lw-scanner" do
  version "0.27.6"
  sha256 "fa82461fad3bc17bf223469f97fd05a8657b67abfc53f1abdf237062d6228433"

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