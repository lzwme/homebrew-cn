cask "font-dashicons" do
  version :latest
  sha256 :no_check

  url "https:github.comWordPressdashiconsrawmastericon-fontfontsdashicons.ttf",
      verified: "github.comWordPressdashicons"
  name "Dashicons"
  homepage "https:developer.wordpress.orgresourcedashicons"

  deprecate! date: "2024-02-18", because: :discontinued
  disable! date: "2025-02-19", because: :discontinued

  font "dashicons.ttf"

  # No zap stanza required
end