cask "finch" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.7.2"
  sha256 arm:   "e7d5b4af4c3623a8648e290583fd0cb1e2bc8d8d8d033326e5a3647c4cc55a7d",
         intel: "92e63a0f26471772a37482cc861ac4d55adacfb00c8a869b0520feae6a295b22"

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