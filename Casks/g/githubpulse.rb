cask "githubpulse" do
  version "0.3.10"
  sha256 :no_check

  url "https:github.comtadeuzagalloGithubPulserawmasterdistGithubPulse.zip"
  name "GithubPulse"
  desc "Statusbar app to help you remember to contribute every day on Github"
  homepage "https:github.comtadeuzagalloGithubPulse"

  livecheck do
    url :homepage
    strategy :github
  end

  app "GithubPulse.app"
end