cask "font-simple-icons" do
  version "16.18.1"
  sha256 "63cdf1bb05aa08986562ae47f2d4a831f089a0678e2c0092938cd49d58e46cd6"

  url "https://ghfast.top/https://github.com/simple-icons/simple-icons-font/releases/download/#{version}/simple-icons-font-#{version}.zip",
      verified: "github.com/simple-icons/simple-icons-font/"
  name "Simple Icons"
  homepage "https://simpleicons.org/"

  font "font/SimpleIcons-Fit.otf"
  font "font/SimpleIcons.otf"

  # No zap stanza required
end