cask "font-codicon" do
  version "0.0.36"
  sha256 "360527575395ad70f940eff1e43eb7c2ec64f4e69f89dc5861b73420d2a578f0"

  url "https:github.commicrosoftvscode-codiconsreleasesdownload#{version}codicon.ttf"
  name "Codicon"
  desc "Icon font for Visual Studio Code"
  homepage "https:github.commicrosoftvscode-codicons"

  font "codicon.ttf"

  # No zap stanza required
end