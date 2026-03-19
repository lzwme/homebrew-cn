class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.15.0/source-code.tar.gz"
  sha256 "4173316629c1b4c20800c256d5b4cbe72b6b99e1e4a78065e399a70b83a304e1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eafae15603d41cec4518c01b5b823be281e880a21d7d2a77295ffb5ea985bff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8792ebfb6793a523955c638e27f01ec2c30ffa18a6ffb4b39e3b23a848cb97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e339acf3d273dd521a28467b987a68b45bf755b3fa22b80d9d9fc2f3e7706a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7f4a87e45287dc5343b790d2f98a37756fb00eb1244ef60b9b7164f1705cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0430dcb345ab39bda8cdba793616a46b09ca799d2bddcb7f98a348819d8a6b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ae29e8f6b4f7f1d603a5e840f393c09fb2dfcf44a9b860fce9eee1245a67c2"
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