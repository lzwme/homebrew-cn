cask "font-simple-icons" do
  version "16.10.0"
  sha256 "4e1c3e8f938ace3ff5d3a437d71194790e97f0acfbd98447f56262ffdbdf641c"

  url "https://ghfast.top/https://github.com/simple-icons/simple-icons-font/releases/download/#{version}/simple-icons-font-#{version}.zip",
      verified: "github.com/simple-icons/simple-icons-font/"
  name "Simple Icons"
  homepage "https://simpleicons.org/"

  font "font/SimpleIcons-Fit.otf"
  font "font/SimpleIcons.otf"

  # No zap stanza required
end