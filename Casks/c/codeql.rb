cask "codeql" do
  version "2.17.4"
  sha256 "f7fb0d2ea5dbe474381e7aa6386589c7e38fb2e68bcf80bf556f270c055b6b91"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end