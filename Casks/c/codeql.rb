cask "codeql" do
  version "2.15.4"
  sha256 "f377fd56de188b825120f60276fe5adbceb71e9d631038d741efe0151929a65f"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end