cask "the-battle-for-wesnoth" do
  version "1.18.4"
  sha256 "a12904628042e42c2c1dd7292c54c72a199a591c3e13d823ac3236a421e1fbb8"

  url "https://downloads.sourceforge.net/wesnoth/Wesnoth_#{version}.dmg",
      verified: "sourceforge.net/wesnoth/"
  name "The Battle for Wesnoth"
  desc "Fantasy-themed turn-based strategy game"
  homepage "https://www.wesnoth.org/"

  livecheck do
    url "https://wiki.wesnoth.org/Download"
    regex(/href=.*?Wesnoth[._-]v?(\d+\.\d*[02468](?:\.\d+)*[a-z]?)\.dmg/i)
  end

  depends_on macos: ">= :sierra"

  app "The Battle for Wesnoth.app"

  zap trash: [
    "~/Library/Application Scripts/org.wesnoth.Wesnoth",
    "~/Library/Containers/org.wesnoth.Wesnoth",
  ]
end