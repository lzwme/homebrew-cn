cask "iloader" do
  version "2.2.5"
  sha256 "a01bf620cf91d701ec7935b0c6fc1fa0c3f1d9af5563e72164ed55293e0bfaf5"

  url "https://ghfast.top/https://github.com/nab138/iloader/releases/download/v#{version}/iloader-darwin-universal.dmg",
      verified: "github.com/nab138/iloader/"
  name "iloader"
  desc "iOS Sideloading Companion"
  homepage "https://iloader.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true
  depends_on :macos

  app "iloader.app"

  zap trash: "~/Library/Application Support/me.nabdev.iloader"
end