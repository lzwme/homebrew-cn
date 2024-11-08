cask "lw-scanner" do
  version "0.27.1"
  sha256 "b9df89e3005d70ceb1c8fd3ce2735852aa4dfb96555e1867b32b1590377e8ba8"

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