cask "colorpicker-materialdesign" do
  version "2.0.0"
  sha256 "244efc1d45c11dbffc478fc92b25ae777b4cfde463b06663290cc8352d6a2464"

  url "https://ghfast.top/https://github.com/CodeCatalyst/MaterialDesignColorPicker/releases/download/v#{version}/MaterialDesignColorPicker.colorPicker.zip"
  name "Material Design"
  desc "Colour picker"
  homepage "https://github.com/CodeCatalyst/MaterialDesignColorPicker"

  colorpicker "MaterialDesignColorPicker.colorPicker"

  # No zap stanza required
end