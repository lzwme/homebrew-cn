cask "graphql-playground" do
  version "1.8.10"
  sha256 "43d54be598ec83dddcaee789e8434c547d0ff1a49ffc2d95fb798996293b7f13"

  url "https:github.comprismagraphql-playgroundreleasesdownloadv#{version}graphql-playground-electron-#{version}.dmg"
  name "GraphQL Playground"
  desc "GraphQL IDE for better development workflows"
  homepage "https:github.comprismagraphql-playground"

  deprecate! date: "2024-07-11", because: :unmaintained

  app "GraphQL Playground.app"

  zap trash: [
    "~LibraryCachescool.graph.playground",
    "~LibraryCachescool.graph.playground.ShipIt",
    "~LibraryHTTPStoragescool.graph.playground",
    "~LibraryPreferencescool.graph.playground.helper.plist",
    "~LibraryPreferencescool.graph.playground.plist",
    "~LibrarySaved Application Statecool.graph.playground.savedState",
  ]

  caveats do
    requires_rosetta
  end
end