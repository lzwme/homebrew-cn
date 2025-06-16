cask "font-greybeard" do
  version "1.0.0"
  sha256 "ddb9075cc4156e90f156bb17c2e91a59a731d3c9fc0350631adafa99d6affbf9"

  url "https:github.comflowchartsmangreybeardreleasesdownloadv#{version}Greybeard-v#{version}-ttf.zip"
  name "Greybeard"
  homepage "https:github.comflowchartsmangreybeard"

  no_autobump! because: :requires_manual_review

  font "Greybeard-11px-Bold.ttf"
  font "Greybeard-11px.ttf"
  font "Greybeard-12px-Bold.ttf"
  font "Greybeard-12px.ttf"
  font "Greybeard-13px-Bold.ttf"
  font "Greybeard-13px.ttf"
  font "Greybeard-14px-Bold.ttf"
  font "Greybeard-14px.ttf"
  font "Greybeard-15px-Bold.ttf"
  font "Greybeard-15px-BoldItalic.ttf"
  font "Greybeard-15px-Italic.ttf"
  font "Greybeard-15px.ttf"
  font "Greybeard-16px-Bold.ttf"
  font "Greybeard-16px-BoldItalic.ttf"
  font "Greybeard-16px-Italic.ttf"
  font "Greybeard-16px.ttf"
  font "Greybeard-17px-Bold.ttf"
  font "Greybeard-17px-BoldItalic.ttf"
  font "Greybeard-17px-Italic.ttf"
  font "Greybeard-17px.ttf"
  font "Greybeard-18px-Bold.ttf"
  font "Greybeard-18px-BoldItalic.ttf"
  font "Greybeard-18px-Italic.ttf"
  font "Greybeard-18px.ttf"
  font "Greybeard-22px-Bold.ttf"
  font "Greybeard-22px.ttf"

  # No zap stanza required
end