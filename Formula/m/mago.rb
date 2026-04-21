class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.23.1/source-code.tar.gz"
  sha256 "3aa99a49c21f217fb1c60bc006480dc5886e3910cf306b30494461934ad02843"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318bf2b6647dfb918aa9fcb6e5ded4aee2c447eea034e8b6f2d8a64f3a93f0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7e202536f4657ea14b6faa1df7c4c7ff8d647a248d9d235316146ff6bd0e6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ecf4ae13b7a3720d154dd18f765ef8778f53935f38d5df687ec78adcfbcf97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa133cf5636c31a1e6195cac36f03a2f6fb0548b5a58bc7069a29d3525adb2d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e74192743da5f443f3ed8962b9ce7a5d093024093ba670b723d66c16fd49a127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887e1b607ef4b2682f535b5adc3e9ab1bd8679ae92956de5caa92c8c4baa5c8a"
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
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end