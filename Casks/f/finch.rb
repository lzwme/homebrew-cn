cask "finch" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.15.0"
  sha256 arm:   "c59a329b28d3bea7c9f8e67c46dba549011282534704ef37f550cd373f65236f",
         intel: "849edf92fd713000a196a1aefb2cf82a402c3981f4946aa125800661941854e2"

  url "https://ghfast.top/https://github.com/runfinch/finch/releases/download/v#{version}/Finch-v#{version}-#{arch}.pkg"
  name "Finch"
  desc "Open source container development tool"
  homepage "https://github.com/runfinch/finch"

  livecheck do
      url :url
      strategy :github_latest
  end

  pkg "Finch-v#{version}-#{arch}.pkg"

  uninstall script: {
    executable: "/Applications/Finch/uninstall.sh",
    sudo:       true,
  }

  zap trash: "~/.finch"
end