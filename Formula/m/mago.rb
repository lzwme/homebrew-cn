class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.20.0.tar.gz"
  sha256 "65909db4f266ca861896eefd2e5ee7458b7d3b0a6765b2615c70455e9894b206"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223060fd779920c9efd5fc06bd43e290a43c69ec2ebffc727bcd276b7d46fa95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c6f67739eb849e869247a7c6957ce3b01a678b53f98e4bdb4d684d0d7cab1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "635dbdbdff9e893515a0467bf3fb516d541e4fca63319bd89c22ca492b3f90e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df3f88cc0469ab4702979e47761c17d989d1b15286f6d3c5c45409ae72a24c4"
    sha256 cellar: :any_skip_relocation, ventura:       "ad13844d816b2ef7e2638f7ac53bddceb70398018a94b9bd423fdbb095fa8992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "382db39b26120ad747fccc94b19d86a0ccd615b978954de3418d90d6d1268a35"
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
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php echo 'Unformatted';\n", (testpath"unformatted.php").read
  end
end