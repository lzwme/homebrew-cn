cask "fossa" do
  arch arm: "arm64", intel: "amd64"

  version "3.17.3"
  sha256 arm:   "973dfbb50531f6c92b17e45d923b6ac2f6f3b137fb4dcefa422db97893aff04d",
         intel: "9e8c93f11c2f0edc06cf9bb20105955cf929b58364138bd3411416c2bcc66506"

  url "https://ghfast.top/https://github.com/fossas/fossa-cli/releases/download/v#{version}/fossa_#{version}_darwin_#{arch}.zip",
      verified: "github.com/fossas/fossa-cli/"
  name "FOSSA"
  desc "Zero-configuration polyglot dependency analysis tool"
  homepage "https://fossa.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  binary "fossa"

  # No zap stanza required
end