cask "font-eldur" do
  version "0.0.5"
  sha256 "9ed5867dc7481a98bcf97ed68b1c3ca5886d8175431d2e38ba3a7a7f90f78392"

  url "https:github.commolarmanfuleldurreleasesdownloadv#{version}eldur.ttf"
  name "eldur"
  homepage "https:github.commolarmanfuleldur"

  font "eldur.ttf"

  # No zap stanza required
end