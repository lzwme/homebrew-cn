cask "emacsclient" do
  version "1.0"
  sha256 :no_check

  url "https:github.comsprigorg-capture-extensionrawmasterEmacsClient.app.zip"
  name "emacsclient"
  desc "ChromeFirefox extension that facilitates org-capture in emacs"
  homepage "https:github.comsprigorg-capture-extension"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "EmacsClient.app"
end