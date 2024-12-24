class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.15.tar.gz"
  sha256 "e82ed722413f48b1e77d6df9559f774bb0168adea44ab84a1aa6bbf49b8ed9f6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4444110bfb1ba198386754f7715c2abddb6ef592f4328c2515c1c48d5eab83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6a86148ba7eb2f49c14c910a683de90b86baa5153e30372223cd7ae5b3bece9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "959d39a7862f9d9391b29a23743c3e50f8718beb049e50a8bf429e735c1bd61c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe58c1945f76ee0402d874706f3d3b23c8725347553061ecaf2defc92104f7b"
    sha256 cellar: :any_skip_relocation, ventura:       "3881254f5bcbcecc9de0b4ef213c37755c218f45943cbcde1cb297b6fcb79b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d937f69a1078ac72d63461db4017cedc09e3b2a16d0a584f7ac2220456951d26"
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
    output = shell_output("#{bin}mago lint 2>&1", 1)
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end