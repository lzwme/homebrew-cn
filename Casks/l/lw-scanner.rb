cask "lw-scanner" do
  version "0.27.0"
  sha256 "2bc25d2734d5f4a69982e9aed670003965505a875b3ea5495e792b6811bade1e"

  url "https:github.comlaceworklacework-vulnerability-scannerreleasesdownload#{version}lw-scanner-darwin-amd64",
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