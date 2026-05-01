cask "tritium" do
  arch arm: "arm64", intel: "x86"

  version "0.2.38"
  sha256 arm:   "5452c8ca13c1e62a43f99590e0693e6660614aa040d75c79f47f04d8db47e73e",
         intel: "d4477ae7bdf7a49cfa14231b0a31530c615a51ccf6c09430cd4b8bad1765ee3b"

  url "https://tritium.legal/static/releases/tritium-macos-#{arch}.#{version}.zip"
  name "Tritium"
  desc "Integrated drafting environment for legal professionals"
  homepage "https://tritium.legal/"

  livecheck do
    url "https://tritium.legal/version"
    strategy :page_match, &:strip
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "tritium.app"

  zap trash: "~/Library/Application Support/com.Tritium-Legal.tritium"
end