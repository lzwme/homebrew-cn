cask "the-cheat" do
  version "1.2.5"
  sha256 "24ed774cc21adc2355077123d04c2657295a41183fd5555c41a2342063c3dedc"

  url "https:chazmcgarvey.github.iothecheatthecheat-#{version}.dmg",
      verified: "chazmcgarvey.github.iothecheat"
  name "The Cheat"
  desc "Game trainer"
  homepage "https:github.comchazmcgarveythecheat"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-09", because: :unmaintained

  app "The Cheat.app"

  caveats do
    requires_rosetta
  end
end