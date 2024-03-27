cask "font-sporting-grotesque" do
  version "1.0"
  sha256 :no_check

  url "https://gitlab.com/velvetyne/Sporting-Grotesque/-/archive/main/Sporting-Grotesque-main.zip",
      verified: "gitlab.com/velvetyne/Sporting-Grotesque/"
  name "Sporting Grotesque"
  desc "Sporting Grotesque font family"
  homepage "https://velvetyne.fr/fonts/sporting-grotesque/"

  font "Sporting-Grotesque-main/fonts/SportingGrotesque-Regular.otf"
  font "Sporting-Grotesque-main/fonts/SportingGrotesque-Bold.otf"
end