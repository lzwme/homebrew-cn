class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.10.0/source-code.tar.gz"
  sha256 "2702e3cb821a0153aaa26406ffb1eca70b129c9aad4ad31efa7634d468667cff"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5db3a8e39cce16e3f71ef2f61785ad01540784fd360cf8f1cab934c4fb536b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222bf43ac298cc894221d44866a78d9a4aa126694b3b2900922f1bc207489d01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3fab89ab7811cd1473cc0c12fac60912090c367441cebbfd3d80fcb8b986ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bea53983c1646b1343aa95caf1e594370690e27104ddcf43b0f404c0122c02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc919ae09475375040fcd37bcce9c0137aa0bb633f405b792b8c98faaf0c67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f6025344e7ad8d86ff4936174c12842b079eb8eeb936d9ef25ac959075c85c"
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