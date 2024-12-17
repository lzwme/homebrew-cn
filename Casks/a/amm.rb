cask "amm" do
  version "0.4.5"
  sha256 "1e9363fecf5fd21b2bb82a38f0a72e50468f0336f3f8985df8a36e3029ca6121"

  url "https:github.com15cmAMMreleasesdownloadv#{version}AMM_v#{version}.dmg"
  name "AMM"
  desc "Aria2 Menubar Monitor"
  homepage "https:github.com15cmAMM"

  disable! date: "2024-12-16", because: :discontinued

  app "AMM.app"
end