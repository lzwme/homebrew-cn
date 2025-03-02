class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.14.0.tar.gz"
  sha256 "fb33d91445ae95600d769be301cd7e1453686d732cb76c6faecb2ab776bd3b0d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61874c2749add38538e5d769ef79795c6684d9645c573a9c21a4b1d5d085bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3eb4c8c79a69fc3b5560f1607dbe1544f9b802e2094115400216144bdc5037f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bfcee2e98930461d449e2f168e9fa5830d5b6a5a442338bd9de836eb6809a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "891b921e6470a174cad035bf00865afca432cc72de6f4d1e7c1613965ce3cb01"
    sha256 cellar: :any_skip_relocation, ventura:       "9cc03e828f862567a6c7817794a5a21e45040df723376826ead164c7b7ef765e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c31048e4d54f8bc09a760e4ed7544c7d422fe048da49b7e64d7eadf26b88e6fb"
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