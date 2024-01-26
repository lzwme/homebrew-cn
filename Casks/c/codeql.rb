cask "codeql" do
  version "2.16.1"
  sha256 "84e4770f93093d2cf4d738af7bab3824bba2942fe03f238ce4b1ef85322fe7ab"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required
end