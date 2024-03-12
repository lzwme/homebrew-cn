cask "codeql" do
  version "2.16.4"
  sha256 "fa339442e11bd51666e232390fc944b115adfbe7cbfda8ae15dafce63b1cc58a"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end