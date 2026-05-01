class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.25.1/source-code.tar.gz"
  sha256 "dc2d37e182e9171de6672084674c4e44212b31341e3ed893991e4da5ce860712"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3182e53e64a257c75dc57c1028d8eb6c05ec7f0946814e138e007eb17d10531d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8a2c2d63c4925f632d6b36bdb9f239e3e8b275c9622817a02befcbd9641d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f28df256a6123c9d0bbf1f33a0736c210392bbe502d6ec4a0bc3638b5360557b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c3b4d1a1ce43add9c46e24b90d4c1a37c0c5cb1661436953b8cb7038559d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9983ea67abc996f954088f3b670f4e4ebf96bcf8b5130f93f34b63b581fb28ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4885b504639798bca39a4208a3d0a21b42f0aaea679e944b35cebe6c9c6d0ee4"
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