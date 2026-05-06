cask "fossa" do
  arch arm: "arm64", intel: "amd64"

  version "3.17.4"
  sha256 arm:   "4ef2e5dd50b1066b16fd6a7921ba6f45a175a5eff5466631def00aafad8d20b4",
         intel: "c30bc679320f1b5ebff0a44f52d5d355990ff315db201a0a56c99f5ab31765fc"

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