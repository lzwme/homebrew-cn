class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.19.5.tar.gz"
  sha256 "e1dffc39485a792f0f9c789d055d0eb1d1caf07e3e6fa40a990ce6b59e4e62bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de7774561fcaeab9bd8ad4928b890c014db4bfb4dda9ab283488021534861db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d3dca96bcad8028dfbcc65011541276e82845b9cb41475fe4916c7f7136a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce9edbd53c216a39e0bfabdb5b167840d161d9918cd1f4d3e0c34ab2199689a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "617f3b3444f15ad94943b8576ec9a4422b0ee8311139bdb0f470ddd7cddd8a73"
    sha256 cellar: :any_skip_relocation, ventura:       "678da580e0dcfafdc255f87685d365e06398c3fd55adf6b875ef8a6fb8bfdf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31c162fa25d00916bd0a9c99699399275e5fbd064bb22ad6bb60501a02b9d87"
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