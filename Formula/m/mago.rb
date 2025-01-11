class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.19.tar.gz"
  sha256 "31770061b73cfd80bf188c3a783efd77ad30f6191c2314ec0676f28a2a378d9c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eddde4479cb55d65750a8d675e2acbfd1502acbb5dc50ecabe6002c6aaabf408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7a809eb2f6b4f254f829ae08f75a30856f2d3eab367b7ac78e582acccf62fd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e8fc0c297715678de0a6965b7fd78f8981feace2d3149679c71975a793d5141"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fbda29fe7a477c740c9332d55181f706f75f9b3d8b16f3d04df87f4514552e6"
    sha256 cellar: :any_skip_relocation, ventura:       "46ed12d96ec8437811f67d62e5ffa71879f61c6d3eb058efb16dc814ad92b865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9733fdab2befca9f37151941833bdb05c53b6b6f31875e7c48dd69ab340d14"
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
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end