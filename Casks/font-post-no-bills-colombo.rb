cask "font-post-no-bills-colombo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpostnobillscolombo"
  name "Post No Bills Colombo"
  homepage "https:fonts.google.comspecimenStick+No+Bills"

  font "PostNoBillsColombo-Bold.ttf"
  font "PostNoBillsColombo-ExtraBold.ttf"
  font "PostNoBillsColombo-Light.ttf"
  font "PostNoBillsColombo-Medium.ttf"
  font "PostNoBillsColombo-Regular.ttf"
  font "PostNoBillsColombo-SemiBold.ttf"

  # No zap stanza required
end