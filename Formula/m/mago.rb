class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.20.2.tar.gz"
  sha256 "a1ae5c465bfd98b1623cde74bca1806bd853fa4f7beff364144fa1d5ed6b6298"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb25e416d4fe4726a59fba899ab9bdc93c9ea0942d1dbef51bf407adc4a8aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03dd32fdc304c60196ec12aef2d69e98630d7adaaf666c6a1a8a53e6af5b502d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9400bfaa555795823c7efadf41fc58d26f02b7b8c8206bfd677df91dd6b475af"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e2d1de3ce2b93566b7ba88bfe0de6da7fc4a161428c09e673aa0f0950f56bfd"
    sha256 cellar: :any_skip_relocation, ventura:       "8adff44d66840459bf6cc13721f610dff71da3a0bdea226facde6d38571757d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f741841558da124e5d56bd7daa130d9006e00d6c1bb5823b0bcb6a271f7797"
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