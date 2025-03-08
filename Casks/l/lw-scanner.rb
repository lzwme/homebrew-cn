cask "lw-scanner" do
  version "0.27.3"
  sha256 "5910a73a248ff603045706665cf47f529e3aaa3e9e2728ea7716f8c3711da749"

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