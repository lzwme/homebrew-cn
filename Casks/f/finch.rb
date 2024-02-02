cask "finch" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.1.1"
  sha256 arm:   "7110f407fddca2dd0c14b9d3432bdda324cb690e352bb79ed184a7b1a6135c82",
         intel: "21e4594799d2a6a4175eebcbb0c1d26e9cb830120a0d8e36e44695543f63ce79"

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