cask "finch" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.6.1"
  sha256 arm:   "79c3d4c487cd73c9eb3c1e3321ce5be96f53302760c25145f7e8a6bb2a36e8a2",
         intel: "337906421b8b4e4e5b698882240be986003cce74e51dad0be368152ad71e2b6a"

  url "https:github.comrunfinchfinchreleasesdownloadv#{version}Finch-v#{version}-#{arch}.pkg"
  name "Finch"
  desc "Open source container development tool"
  homepage "https:github.comrunfinchfinch"

  pkg "Finch-v#{version}-#{arch}.pkg"

  uninstall script: {
    executable: "ApplicationsFinchuninstall.sh",
    sudo:       true,
  }

  zap trash: "~.finch"
end