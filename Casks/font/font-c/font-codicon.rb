cask "font-codicon" do
  version "0.0.36"
  sha256 "360527575395ad70f940eff1e43eb7c2ec64f4e69f89dc5861b73420d2a578f0"

  url "https:github.commicrosoftvscode-codiconsreleasesdownload#{version}codicon.ttf"
  name "Codicon"
  homepage "https:github.commicrosoftvscode-codicons"

  no_autobump! because: :requires_manual_review

  font "codicon.ttf"

  # No zap stanza required
end