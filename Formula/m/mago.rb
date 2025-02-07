class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.9.0.tar.gz"
  sha256 "fbdbdf4a9ed193d0bb611dac5d52d8a370251baf0e0ec8ab9cd9ee120d982c9c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9a260ccd572a974e83c85163bb04ae270606017d10f52a292705512c09dde1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2a44931cff9e8ae0986434849960a51965da10bb386a1d3d5df9fd4e76d822"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45e819ce6c367b0066667759ec8601fec2914856f0a2989408b5080641bb1a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4bf0f952ffd472931701db96db94863fdbcbba7512adc38b96b219f3b35601"
    sha256 cellar: :any_skip_relocation, ventura:       "f489d3bc7a150a3aa0f3436b9a744dfda9c3911094b925d3d2f0ea1056e780b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329b9f7608a05fbb98d6434d9e1bf9d1afdb90d97dd463098c98fc095564f98a"
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