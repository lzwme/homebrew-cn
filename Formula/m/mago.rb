class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.56.2/source-code.tar.gz"
  sha256 "3a595733082f215319eb0cf43350767438c2e0c2e4c0e79e37f8426bdad61209"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24a3cd05431038e0cac68048f5cde33e8905a6c772ec56957c0351d3f2ff8da9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ac07d978ec3fb3197a71747028a7fac806476e50c9011fdf02472cb5415423d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcfe37a204f8a9068c25d2defe209c425f6d88694f94d4900fe2fc6f8415ea65"
    sha256 cellar: :any,                 arm64_linux:       "e7a5560148d2b9b1202388e5355328defdda9fc2eab7eb8ae464450677852507"
    sha256 cellar: :any,                 x86_64_linux:      "5d33314828e28892ff0869b9496554bcdf3344c2f81b6ef0875b9beb947798d3"
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