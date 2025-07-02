cask "lw-scanner" do
  arch arm: "arm64", intel: "amd64"

  version "0.27.8"
  sha256 arm:   "cc59ef0a957fa06cc67f4bba7df3dcd31fb8390291aa8899310fe5a2094217d8",
         intel: "3726ec23121655360f6d5c036dfeeb55a4bfa4c720ebd6021591c45509883fb8"

  url "https:github.comlaceworklacework-vulnerability-scannerreleasesdownloadv#{version}lw-scanner-darwin-#{arch}.zip",
      verified: "github.comlaceworklacework-vulnerability-scanner"
  name "Lacework vulnerability scanner"
  desc "Lacework inline scanner"
  homepage "https:docs.lacework.netconsolelocal-scanning-quickstart"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "binlw-scanner"

  zap trash: "~.configlw-scanner"
end