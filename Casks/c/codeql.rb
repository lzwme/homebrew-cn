cask "codeql" do
  version "2.25.3"
  sha256 "5b7decd43677112eafa6bb2eacdeed9c2e7a8865a6a26039c331481746ecd3db"

  url "https://ghfast.top/https://github.com/github/codeql-cli-binaries/releases/download/v#{version}/codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https://codeql.github.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  binary "#{staged_path}/codeql/codeql"

  # No zap stanza required
end