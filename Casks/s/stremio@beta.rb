cask "stremio@beta" do
  arch arm: "arm64", intel: "x64"

  version "5.1.21"
  sha256 arm:   "806e1e2510649b4e0f2b579c304a184ee73424720de0defde699548172fdc929",
         intel: "d25c7f5d5ff26b735c690114f6809caffefd4bb42bab8bf295ac15a899f470c6"

  url "https://dl.strem.io/stremio-shell-macos/v#{version}/Stremio_#{arch}.dmg"
  name "Stremio"
  desc "Open-source media center"
  homepage "https://www.strem.io/"

  livecheck do
    url "https://www.stremio.com/updater/check?product=stremio-shell-macos&arch=#{arch}"
    strategy :json do |json|
      json["version"]
    end
  end

  conflicts_with cask: "stremio"
  depends_on macos: ">= :big_sur"

  app "Stremio.app"

  zap trash: [
    "~/Library/Application Support/Smart Code ltd",
    "~/Library/Application Support/stremio-server",
    "~/Library/Caches/Smart Code ltd",
    "~/Library/Preferences/com.smartcodeltd.stremio.plist",
    "~/Library/Preferences/com.stremio.Stremio.plist",
    "~/Library/Saved Application State/com.smartcodeltd.stremio.savedState",
  ]
end