cask "guppy" do
  version "0.3.0"
  sha256 "9e65c7df1c77dc78f469984e2bf06351254de72e98b20a12396536946116c80c"

  url "https:github.comjoshwcomeauguppyreleasesdownloadv#{version}Guppy-#{version}.dmg"
  name "Guppy"
  desc "Friendly application manager and task runner for React.js"
  homepage "https:github.comjoshwcomeauguppy"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Guppy.app"

  zap trash: "~LibraryApplication SupportGuppy"
end