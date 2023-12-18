cask "graphiql" do
  version "0.7.2"
  sha256 "204dd3db5c11bf265700d8d57defc4798cd0040651f751f35e2a646cb4846ac7"

  url "https:github.comskevygraphiql-appreleasesdownloadv#{version}graphiql-app-#{version}-mac.zip"
  name "GraphiQL App"
  desc "Light, Electron-based Wrapper around GraphiQL"
  homepage "https:github.comskevygraphiql-app"

  app "GraphiQL.app"

  zap trash: [
    "~LibraryApplication SupportGraphiQL",
    "~LibraryPreferencescom.sk3vy.graphiql-app.helper.plist",
    "~LibraryPreferencescom.sk3vy.graphiql-app.plist",
    "~LibrarySaved Application Statecom.sk3vy.graphiql-app.savedState",
  ]
end