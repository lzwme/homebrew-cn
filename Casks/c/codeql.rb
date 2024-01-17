cask "codeql" do
  version "2.16.0"
  sha256 "0bfc52093d997dbaab930cb1cd34103fe404ef1a557d41009a59813b38379477"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end