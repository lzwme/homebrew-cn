class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.12.0.tar.gz"
  sha256 "41fbb80c8543f920b57d461f637d1a24cc203f32c589d7a948a4347384faa6bc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295142e32fa9abe1b84dc5cce2ec16f485e203eb13411458f3fe6e1f96378804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5027f6c4dbc914fd819f8cb633394ac57b7225ee62b4c1b7794a1c5e291ef49b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf03aab00ec882215272291df86ac879cbab7e654d088ee07b8c962c8b71efbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "06173ea29ccf89ccc9dbeb6eab4674a5af63153ab31a66787d8518c56cc96df9"
    sha256 cellar: :any_skip_relocation, ventura:       "0ca56f3747cc95d95d68112fe7a87838824bd22dc50d9613e0fb375bfbf197c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446216333a4832ee74ddaf0dc128809703873d49cad6fe21dd467e33999fa40f"
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