cask "wing-personal" do
  version "10.0.9.0"
  sha256 "8cbfcd7d47c3ab83ff224e1381f1846165af78c3ca4cde647b8b40aacdab888b"

  url "https://wingware.com/pub/wing-personal/#{version}/wing-personal-#{version}.dmg"
  name "Wing Personal"
  desc "Free Python IDE designed for students and hobbyists"
  homepage "https://www.wingware.com/"

  livecheck do
    url "https://wingware.com/downloads/wing-personal"
    regex(%r{href=.*?/pub/wing-personal/v?(\d+(?:\.\d+)+)}i)
  end

  depends_on macos: ">= :catalina"

  app "Wing Personal.app"

  zap trash: [
    "~/.wingpersonal#{version.major}",
    "~/Library/Application Support/Wing Personal",
    "~/Library/Caches/com.apple.python/Applications/Wing Personal.app",
    "~/Library/Caches/com.wingware.wing-personal",
    "~/Library/Saved Application State/com.wingware.wing-personal.savedState",
  ]
end