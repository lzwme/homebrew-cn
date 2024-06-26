cask "font-ia-writer-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comiaoloiA-Fontsarchiverefsheadsmaster.tar.gz"
  name "iA Writer Mono"
  homepage "https:github.comiaoloiA-Fonts"

  font "iA-Fonts-masteriA Writer MonoStaticiAWriterMonoS-Bold.ttf"
  font "iA-Fonts-masteriA Writer MonoStaticiAWriterMonoS-BoldItalic.ttf"
  font "iA-Fonts-masteriA Writer MonoStaticiAWriterMonoS-Italic.ttf"
  font "iA-Fonts-masteriA Writer MonoStaticiAWriterMonoS-Regular.ttf"
  font "iA-Fonts-masteriA Writer MonoVariableiAWriterMonoV-Italic.ttf"
  font "iA-Fonts-masteriA Writer MonoVariableiAWriterMonoV.ttf"

  # No zap stanza required
end