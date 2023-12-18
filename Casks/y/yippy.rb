cask "yippy" do
  version "2.8.1"
  sha256 "89d8c2c628637cc72ff6f8a3ca0d07484479a1becb66cedaa67a12062d148131"

  url "https:github.commattDavoYippyreleasesdownload#{version}Yippy.zip",
      verified: "github.commattDavoYippy"
  name "Yippy"
  desc "Open source clipboard manager"
  homepage "https:yippy.mattdavo.com"

  app "Yippy.app"

  zap trash: "~LibraryApplication SupportMatthewDavidson.Yippy"
end