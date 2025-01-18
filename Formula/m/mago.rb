class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.1.2.tar.gz"
  sha256 "8e8db6f95ffe1d9ae0ea6e7a39059507c3f318cb2f20153382f3e314b5f8a101"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922bd2bf833b750602944f9764ef7ebda7b161f3e5f671679b648aaa06c506bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b26c19682de05db2b465bb9c77dcb1f68f29ce69654aa9cbccfc725caaf85b50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2a1d0d389f69ce627720223126e8384e31cdc979c06627c128bd35428acc17c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fdbd9bd0e53677f1fe482eda794e926b0ae0b9ea2cb6e9f8896ac5b529cd09d"
    sha256 cellar: :any_skip_relocation, ventura:       "d30bf24f94b4fa70e6e918e57fc83f80d0a110a7b58f46c0ad0a7b609a1c4724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703e48116c49adb38fde820905a85a0e506f717371e9d8f2e945f2cec665a5a4"
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