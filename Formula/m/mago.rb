class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.14.1/source-code.tar.gz"
  sha256 "5108e0d13c12b4ab8b86dcebd7e4f473e8a01fd0b7ed319855f3015498a8eab8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73d19bb2d260d41964a1298f28e92562ffc97c2769e039c5d8b2a95b09e0b044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27087913f1330e4faadd9889136f731f1dd147a89908edd23422b8bc8817d01b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829c00fc555ac1f7e589ed59c3af247b0e1ebaf557be39b7c9bc173cd1ae21a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8249056c15fccc9aa1d44f0cc8a454395d814f5837b1986b4d8a57c050ed764a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7575949b1483c8603e4ee74d5801e926eb47ee1737209acd4e6ec59be550233e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a4e1667d4cf328fe0be8d5b514ae3d65656dac6471f73043a16ba20e38032b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end