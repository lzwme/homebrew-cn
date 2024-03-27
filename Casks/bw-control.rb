cask "bw-control" do
  version "1.2.4"
  sha256 "00b9c66be41eaf0e291ca237b7a312a42f28eccf80c36fd4ce1387c4c0c9d6da"

  url "https://bwfirmware.com/software/airplay_setup/mac/191028_BowersWilkinsControl_#{version}_14697.dmg",
      verified: "bwfirmware.com/"
  name "Bowers & Wilkins Control"
  desc "Bowers & Wilkins Control app for wireless speakers"
  homepage "https://www.bowerswilkins.com/de-de/wireless-speakers-control-app"

  app "Bowers & Wilkins Control.app"
end