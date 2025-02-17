class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.10.0.tar.gz"
  sha256 "6bc25f0412f7f9675dcfb62ab9d1e8cc257af31470cc7fdde2bcd63c8ffd27f9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d568e989eb44ad1061d5382e16f808cf0ba38a986a48b995b69003df85a2071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "045369c84809f18c60d814be8a30170884af2e9218e7bda3a7398777c1aa6053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4bcb936a2c8f8b3b49108838d1c86ff987c54a78c2a531f0f832d8b5998348e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a555dbd20bb78e188216d501b8c17e772c28a3c3ef88825cb797fca9ea5cc90f"
    sha256 cellar: :any_skip_relocation, ventura:       "9cce77da92d8c6bc8346a0ae1485189b5b89dce47fad79fd7e807402450c68bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be1386f63ed295ed6108cf6ffa0d63bd845c522c137fa03f1d8f2d04fb86ede"
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