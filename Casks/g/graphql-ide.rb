cask "graphql-ide" do
  version "1.1.1"
  sha256 "e7aa74f9dfc4874138d9fa74af33eb701130f5abe8ff70735c38c506f732408c"

  url "https:github.comandev-softwaregraphql-idereleasesdownloadv#{version}GraphQL.IDE.zip"
  name "GraphQL IDE"
  desc "IDE for exploring GraphQL APIs"
  homepage "https:github.comandev-softwaregraphql-ide"

  app "GraphQL IDE.app"
end