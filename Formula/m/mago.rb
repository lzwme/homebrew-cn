class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.8.tar.gz"
  sha256 "5d434435542511ecea105bb74053c1ac1ee468b1e2d66ff4909735083d9229d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ac63fa392f08d4c4ca2e0ffff1e520b1fd9c3c37aa32b8a08571f1e2302fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6884a54e5eba00cf59635ebb258f85392fa6f706d46fd1109b70e726704447ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16da1a993b1ed187f04732a35f3c8106a364256c4bb9dcbd17f51b9d6cfceda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8456a6681b44643278a3070c486d1c23f6638ceab62be7abc47b773385aab2"
    sha256 cellar: :any_skip_relocation, ventura:       "f4e202a7490f2712563e445135061b6ed135519f43c96aa8a6129416100fb107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb12f6e3330e81c92bdea70eedc81bf46c0a0f79a07c617e81b47184cacce10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end