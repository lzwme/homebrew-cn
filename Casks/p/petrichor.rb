cask "petrichor" do
  version "1.4.0"
  sha256 "3b696956c7ac0f9a026054a72e58a1a095c6b6f3b7e7d74207e5fff45dae3e59"

  url "https://ghfast.top/https://github.com/kushalpandya/Petrichor/releases/download/v#{version}/Petrichor-#{version}-Universal.dmg"
  name "Petrichor"
  desc "Offline Music Player"
  homepage "https://github.com/kushalpandya/Petrichor"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Petrichor.app"

  zap trash: [
    "~/Library/Containers/org.Petrichor",
    "~/Library/Saved Application State/org.Petrichor.savedState",
  ]
end