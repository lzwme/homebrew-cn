class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.20.4.tar.gz"
  sha256 "3cc8b75b0311b2d430992b761343b298da19c3db01a303ca4609027d82b751ac"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9450a0e625f81561d7f86c048a1f98d1fb8c91125a85b3b16c40efdeeaf7c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783ab7a23456e6b51cea6cbecb7e681e23e0e0de57b4e5a6c2b4a86eb84f0208"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d56d692f0e44d811698a375f15f6ec33e7faeab9d47ad055ab01587cb9ab2d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5728395a87f90da51affae73a0acbca14ecf5fa36b5fdb9fdec12fb049c4a21"
    sha256 cellar: :any_skip_relocation, ventura:       "4b32f14cd17c322d0d21d6470c52c12fdf708265b1641cb1857861658b5d6859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ee4f57effcb86f9494ea66f5b682ef10e36a9b3b0da1175ff3d5ad530f2a8d"
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