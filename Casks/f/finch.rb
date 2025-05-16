cask "finch" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.8.1"
  sha256 arm:   "78086c9608e4ef08d25c9b8f6d513581e8f441a60b6778cef7e8780ac46a422e",
         intel: "7fc9a22bd30fc733649763cd7e4f86535de93f5b5a7744fa7e716f7ed3e0f522"

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