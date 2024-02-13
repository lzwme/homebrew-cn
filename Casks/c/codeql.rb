cask "codeql" do
  version "2.16.2"
  sha256 "c5c3db247bd151b504fb11711f62129832a35e1e2990bf27bb0d2ebebddef610"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end