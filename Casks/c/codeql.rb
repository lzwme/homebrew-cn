cask "codeql" do
  version "2.20.0"
  sha256 "542087485cd1639819cc00b0b83235fb504e16cf66d05ae8e46830b3fdf5ecd4"

  url "https:github.comgithubcodeql-cli-binariesreleasesdownloadv#{version}codeql-osx64.zip"
  name "CodeQL"
  desc "Semantic code analysis engine"
  homepage "https:codeql.github.com"

  binary "#{staged_path}codeqlcodeql"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end