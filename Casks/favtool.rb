cask "favtool" do
  version "4.3"
  sha256 "1ae7d059528041d225aea904aac736b8069991d860a6d0f58c30adfce086bfac"

  url "https://ghfast.top/https://github.com/shy-neon/favtool/releases/download/v#{version}/Favtool.app.zip"
  name "Favtool"
  desc "Easily change icons of your favorite sites on Safari"
  homepage "https://github.com/shy-neon/favtool"

  livecheck do
    url :stable
  end

  app "Favtool.app"

  zap trash: [
    "~/Library/Preferences/shy-neon.Favtool.plist",
    "~/Library/Saved Application State/shy-neon.Favtool.savedState",
  ]
end