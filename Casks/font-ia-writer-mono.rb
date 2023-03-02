cask "font-ia-writer-mono" do
  version :latest
  sha256 :no_check

  url "https://codeload.github.com/iaolo/iA-Fonts/zip/master"
  name "iA Writer Mono"
  homepage "https://github.com/iaolo/iA-Fonts"

  font "iA-Fonts-master/iA Writer Mono/Static/iAWriterMonoS-Bold.ttf"
  font "iA-Fonts-master/iA Writer Mono/Static/iAWriterMonoS-BoldItalic.ttf"
  font "iA-Fonts-master/iA Writer Mono/Static/iAWriterMonoS-Italic.ttf"
  font "iA-Fonts-master/iA Writer Mono/Static/iAWriterMonoS-Regular.ttf"
end