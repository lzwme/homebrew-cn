cask "font-rounded-mplus" do
  version "20150529"
  sha256 "e746736c8ded99fe9a9dd72a241ec59435eaa282a18e7ac33a26dc0578c06ff7"

  url "https://ftp.iij.ad.jp/pub/osdn.jp/users/8/8569/rounded-mplus-#{version}.7z",
      verified: "ftp.iij.ad.jp/pub/osdn.jp/users/8/8569/"
  name "Rounded M+"
  homepage "http://jikasei.me/font/rounded-mplus/"

  livecheck do
    url "http://jikasei.me/font/rounded-mplus/about.html"
    regex(/href=.*?rounded[._-]mplus[._-]v?(\d+(?:\.\d+)*)\.7z/i)
  end

  no_autobump! because: :requires_manual_review

  font "rounded-mplus-1c-black.ttf"
  font "rounded-mplus-1c-bold.ttf"
  font "rounded-mplus-1c-heavy.ttf"
  font "rounded-mplus-1c-light.ttf"
  font "rounded-mplus-1c-medium.ttf"
  font "rounded-mplus-1c-regular.ttf"
  font "rounded-mplus-1c-thin.ttf"
  font "rounded-mplus-1m-bold.ttf"
  font "rounded-mplus-1m-light.ttf"
  font "rounded-mplus-1m-medium.ttf"
  font "rounded-mplus-1m-regular.ttf"
  font "rounded-mplus-1m-thin.ttf"
  font "rounded-mplus-1mn-bold.ttf"
  font "rounded-mplus-1mn-light.ttf"
  font "rounded-mplus-1mn-medium.ttf"
  font "rounded-mplus-1mn-regular.ttf"
  font "rounded-mplus-1mn-thin.ttf"
  font "rounded-mplus-1p-black.ttf"
  font "rounded-mplus-1p-bold.ttf"
  font "rounded-mplus-1p-heavy.ttf"
  font "rounded-mplus-1p-light.ttf"
  font "rounded-mplus-1p-medium.ttf"
  font "rounded-mplus-1p-regular.ttf"
  font "rounded-mplus-1p-thin.ttf"
  font "rounded-mplus-2c-black.ttf"
  font "rounded-mplus-2c-bold.ttf"
  font "rounded-mplus-2c-heavy.ttf"
  font "rounded-mplus-2c-light.ttf"
  font "rounded-mplus-2c-medium.ttf"
  font "rounded-mplus-2c-regular.ttf"
  font "rounded-mplus-2c-thin.ttf"
  font "rounded-mplus-2m-bold.ttf"
  font "rounded-mplus-2m-light.ttf"
  font "rounded-mplus-2m-medium.ttf"
  font "rounded-mplus-2m-regular.ttf"
  font "rounded-mplus-2m-thin.ttf"
  font "rounded-mplus-2p-black.ttf"
  font "rounded-mplus-2p-bold.ttf"
  font "rounded-mplus-2p-heavy.ttf"
  font "rounded-mplus-2p-light.ttf"
  font "rounded-mplus-2p-medium.ttf"
  font "rounded-mplus-2p-regular.ttf"
  font "rounded-mplus-2p-thin.ttf"

  # No zap stanza required
end