cask "font-train-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltrainoneTrainOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Train One"
  homepage "https:fonts.google.comspecimenTrain+One"

  font "TrainOne-Regular.ttf"

  # No zap stanza required
end