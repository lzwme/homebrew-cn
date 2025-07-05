cask "react-proto" do
  version "1.0.0"
  sha256 "2b2f451865fbb2d03e00109c8f452774e881117c2d21d2d1ad543c9ab55df213"

  url "https://ghfast.top/https://github.com/React-Proto/react-proto/releases/download/v#{version}/React-Proto-#{version}.dmg",
      verified: "github.com/React-Proto/react-proto/"
  name "React Proto"
  desc "React application prototyping tool for developers and designers"
  homepage "https://react-proto.github.io/react-proto"

  no_autobump! because: :requires_manual_review

  app "React-Proto.app"

  zap trash: [
    "~/Library/Application Support/react-proto",
    "~/Library/Preferences/com.react.proto*.plist",
  ]
end