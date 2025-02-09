class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.9.1.tar.gz"
  sha256 "51825c431521531c5e190bbe337a032bc08229d52e591f7997cf1fffd8c18105"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c698cecf50baaf498e2d3e823d4063425ffe2986d6cfa8aa6e2997a71141f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51914dfdcfd0ec7b5d3693ed443cfa649d57546485b83a904249d6bea504ab4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c824e1062a8696d313069e4eb222f30d6e9b351f408f6ccbf09700aceb4714b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "77cebff294ba311a2b3502a2dc95ba06ca618cbe8c46bb3cbd5644a38c87a31f"
    sha256 cellar: :any_skip_relocation, ventura:       "f30397f1bb31342b36c2a8298065eb7cb724c2123f6bc954e392bb1b53468225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d62978178b9cdbe02f811eb02c71ce99ec370274a4be93b44e2d8f9b6cb48c8"
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