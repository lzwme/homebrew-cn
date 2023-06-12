class Czkawka < Formula
  desc "Multi functional app to find duplicates, empty folders, similar images etc."
  homepage "https://github.com/qarmin/czkawka"
  url "https://ghproxy.com/https://github.com/qarmin/czkawka/releases/download/6.0.0/mac_czkawka_gui"
  sha256 "3d32505a56f1183164ba8fbd7a568ff32c433de502de0a4ce9359e1ad35158b5"

  depends_on "gtk4"

  def install
    bin.install Dir["*"]
  end
end