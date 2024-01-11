class M1ddc < Formula
  desc "Control external displays (USB-CDisplayPort Alt Mode) using DDCCI on M1 Macs"
  homepage "https:github.comwaydabberm1ddc"
  url "https:github.comwaydabberm1ddcarchiverefstagsv1.2.0.tar.gz"
  sha256 "d633c06502e650108bb2f581b5db25d2592955fa9a57de7feeae3ed7710c59ca"
  license "MIT"
  head "https:github.comwaydabberm1ddc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15f255dfd3bffa355ed5cea88646a647a7cd889070a71f8de30e2f77da35f74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4b3c88cd24a1992cb6eb8fa0c82edc301ef5831de19416cc5691c758b4b03d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0636faa4400e20f160adba62245a506f7c087c6f047b9c2f03ce1db4f3863f"
  end

  depends_on arch: :arm
  depends_on macos: :monterey
  depends_on :macos

  def install
    system "make"
    bin.install "m1ddc"
  end

  test do
    # Ensure helptext is rendered
    assert_includes shell_output("#{bin}m1ddc help", 1), "Controls volume, luminance"

    # Attempt getting maximum luminance (usually 100),
    # will return code 1 if a screen can't be found (e.g., in CI)
    assert_match((\d*)|(Could not find a suitable external display\.), pipe_output("#{bin}m1ddc get luminance"))
  end
end