cask "guppy" do
  version "0.3.0"
  sha256 "9e65c7df1c77dc78f469984e2bf06351254de72e98b20a12396536946116c80c"

  url "https://ghfast.top/https://github.com/joshwcomeau/guppy/releases/download/v#{version}/Guppy-#{version}.dmg"
  name "Guppy"
  desc "Friendly application manager and task runner for React.js"
  homepage "https://github.com/joshwcomeau/guppy"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Guppy.app"

  zap trash: "~/Library/Application Support/Guppy"
end