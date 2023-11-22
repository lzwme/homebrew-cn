cask "font-ia-writer-duospace" do
  version :latest
  sha256 :no_check

  url "https://codeload.github.com/iaolo/iA-Fonts/zip/master"
  name "iA Writer Duospace"
  homepage "https://github.com/iaolo/iA-Fonts"

  font "iA-Fonts-master/iA Writer Duo/Static/iAWriterDuoS-Bold.ttf"
  font "iA-Fonts-master/iA Writer Duo/Static/iAWriterDuoS-BoldItalic.ttf"
  font "iA-Fonts-master/iA Writer Duo/Static/iAWriterDuoS-Italic.ttf"
  font "iA-Fonts-master/iA Writer Duo/Static/iAWriterDuoS-Regular.ttf"
  font "iA-Fonts-master/iA Writer Duo/Variable/iAWriterDuoV-Italic.ttf"
  font "iA-Fonts-master/iA Writer Duo/Variable/iAWriterDuoV.ttf"

  # No zap stanza required
end