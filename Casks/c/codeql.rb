cask "codeql" do
  version "2.19.2"
  sha256 "f41211c1ca231980d811ef21aecbb105f018abea12024ea8dc38154c63aa3564"

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