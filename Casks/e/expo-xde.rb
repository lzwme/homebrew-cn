cask "expo-xde" do
  version "2.25.0"
  sha256 "acc7048dcd9763e6924850595b325a4c38c9d28ab1c07dd07f2bc6058476ed2a"

  url "https:github.comexpoxdereleasesdownloadv#{version}xde-#{version}.dmg",
      verified: "github.comexpoxde"
  name "Expo Development Environment (XDE)"
  homepage "https:expo.io"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Expo XDE.app"
end