cask "password-gorilla" do
  version "15373"
  sha256 "51c443fb58a3628c2a45bd3160096abb9b017f33e6a08628636168f996ad0414"

  url "https:gorilla.dp100.comdownloadsgorilla.mac.#{version}.zip",
      verified: "gorilla.dp100.com"
  name "Password Gorilla"
  desc "Password database manager"
  homepage "https:github.comzdiagorilla"

  livecheck do
    url "https:gorilla.dp100.comdownloads"
    regex(gorilla\.mac\.(\d+)\.zipi)
  end

  app "Password Gorilla.app"
end