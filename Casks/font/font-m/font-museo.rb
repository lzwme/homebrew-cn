cask "font-museo" do
  version "2.002"
  sha256 :no_check

  url "https://abstractfonts-downloads.s3.amazonaws.com/zips/1/4/8/9/0/contents/museo-300.zip",
      verified: "abstractfonts-downloads.s3.amazonaws.com/"
  name "Museo"
  homepage "https://www.abstractfonts.com/font/14890"

  livecheck do
    skip "No version information available"
  end

  font "Museo300-Regular.otf"
  font "Museo700-Regular.otf"

  # No zap stanza required
end