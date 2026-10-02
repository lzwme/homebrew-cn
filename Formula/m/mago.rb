class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.51.0/source-code.tar.gz"
  sha256 "787dd4dad1d7c2afee86f1f762c9f070d6afad1d11f6766be8ccaa282dfa5fba"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de11421c17f7c2f20f756e817ad6f590f79cde9be588adda099088c3cb8707b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c01e2a5c29f106fec007ab60ff354f4d01e2c0c59ca45e85bae6fe83da1d18e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b2433f513f9c4ca936850d248ba73f378187676dbf3134dfca8b2719193d611"
    sha256 cellar: :any,                 arm64_linux:       "08a8a574eaa2437f9818a2c25db3142e1a9fb6633d855246e7be95a35dfbe2e2"
    sha256 cellar: :any,                 x86_64_linux:      "612ced37c1a1a5bfca5ec6b01a9a2963fd5ed2066b31c60087bcf1d5a92b47d2"
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