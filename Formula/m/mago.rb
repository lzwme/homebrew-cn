class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.19.0.tar.gz"
  sha256 "8ff9f951a437464035c17898a2153aa103e11c566861b6052a4cc1e6f2f25a49"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a5cce23659b501f2ca29173b366b55f97d3cc2e95deb7ef524d4eecddc9580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b945e285e3115c78813f7498c84a557dd2ec4a291de839add3f90305e3cac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4de34a6369cb7c94edfe4558786eb00111ec8f4612bc7432125f50025f07185"
    sha256 cellar: :any_skip_relocation, sonoma:        "d169282a1d0a9a0d2fc29f922663950626f78b08defa812a8166e48aa38dfc57"
    sha256 cellar: :any_skip_relocation, ventura:       "1497b6d19d9dcc76dcd8c0572cb3091c990c2d0d8577b2cbc34839bed1909c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a565bcb6a17c3c6fa03f4a5051981292b42a32fa43fd5660de5b74a3faaedbd9"
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