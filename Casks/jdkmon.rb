cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "21.0.13"
  sha256 arm:   "5a625973aa39c612c005bc3140a48d3e8f2cd42ee6270744210c2cf1d72c77db",
         intel: "4865e73fe50b1ac6a647596dfc70854b64ecb62bec15e13aff22f62137e2913e"

  url "https://ghfast.top/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  livecheck do
    strategy :github_latest
  end

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end