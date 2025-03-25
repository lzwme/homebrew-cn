class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.22.1.tar.gz"
  sha256 "56320190767144d360b4d756dd605fa98a23accaecf7f30e20057eef78a05c09"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f1bb9083c5c6bee31bca4b0d39d4ec3684db554e566f1b85db62459f12cc64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d5049d73fc23ff72396d75dcab9ae532075b99ba4c5ec257bf869628bc69463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c9e7801fd2a04e913f861116c8e9a3c34a2a7dd1b75bac260938649f21b0798"
    sha256 cellar: :any_skip_relocation, sonoma:        "6982846f66046d33388948ab3db759a1d0c57a6b2859ee7d6f9bf167c9c59015"
    sha256 cellar: :any_skip_relocation, ventura:       "1badc4d1682cad53a4f1e7f0c4504115066ae982b1c9f7900cc5bd4e997b84d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b82a459b0e268307c18932eb0905a97689ec88324d3b945893cfd6e839045bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd4900664639d22c570c5b42450414862b1430b409caf6b2ea3de7b1bd0380f"
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