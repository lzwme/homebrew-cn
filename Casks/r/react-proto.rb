cask "react-proto" do
  version "1.0.0"
  sha256 "2b2f451865fbb2d03e00109c8f452774e881117c2d21d2d1ad543c9ab55df213"

  url "https:github.comReact-Protoreact-protoreleasesdownloadv#{version}React-Proto-#{version}.dmg",
      verified: "github.comReact-Protoreact-proto"
  name "React Proto"
  desc "React application prototyping tool for developers and designers"
  homepage "https:react-proto.github.ioreact-proto"

  app "React-Proto.app"

  zap trash: [
    "~LibraryApplication Supportreact-proto",
    "~LibraryPreferencescom.react.proto*.plist",
  ]
end