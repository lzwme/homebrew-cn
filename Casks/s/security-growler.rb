cask "security-growler" do
  version "2.3"
  sha256 "ef00c7effca5fb1001498c3490190f9c923bbefa2a0dd2c21df15374bd23c962"

  url "https:github.compiratesecurity-growlerreleasesdownloadv#{version}Security.Growler.app.zip"
  name "Security Growler"
  homepage "https:github.compiratesecurity-growler"

  disable! date: "2024-12-16", because: :discontinued

  app "Security Growler.app"
end