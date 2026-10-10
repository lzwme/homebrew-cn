class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.55.0/source-code.tar.gz"
  sha256 "8234183e9498e5a0f5b55fa0e9aced2a5d681614e85141bfebd9a53e8fbe20ab"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c43a003ac81558d2f0d97aac73acbe17decf2ab79be4b54e38ca301ba40c7e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42615d25b3050965979bf1bbdb270226e5c009509f3ce0df21c24e82f11929a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b78f61216471905cc5fd89f1b93cccf107c047fba831b68e43bd91c67b953fc1"
    sha256 cellar: :any,                 arm64_linux:       "12800b86b45689d2ccdd02388f43c7730551b05a07e16f258e8d2e8dcca4e633"
    sha256 cellar: :any,                 x86_64_linux:      "5afc3e581b4d36a571c7667e1df86046389ce20ba4e4360364cfe589e3f4e1ea"
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