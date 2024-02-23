cask "codeql" do
  version "2.16.3"
  sha256 "a6c6f540d1afe48c37a2675a7d067d1751ffebaf5bd0745f4b6bb5c095ff02de"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end