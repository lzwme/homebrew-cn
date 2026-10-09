class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.54.0/source-code.tar.gz"
  sha256 "d67dca98a2e676962ef378f6550dc34def6314b5ce0f09baf8a3e80b7ea7f5bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "651d2febb6093917de00f399ae1baaaf543f4e63699a1d9122b2bbaaa7149d68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b9bdccca71d79934294b7e10baac77dad19124cb04c51ff38707ebb1caf4f83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64322d761e6dd03604731b37e5453239b691631bcd53de003d0fc71637bc5de3"
    sha256 cellar: :any,                 arm64_linux:       "c7c98da622f9903eb68bafc11324c7b90d1a4953bb3ed2696343db1e74ebf32d"
    sha256 cellar: :any,                 x86_64_linux:      "dd38b3ce08f8eb3b2daef28ee1a8d324e8ecceb7e0638f508693deba974ab570"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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