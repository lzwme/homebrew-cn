class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.13.tar.gz"
  sha256 "76815b8c8f8cf262dac5cb7b056985e6652c155f99663b0790638e1fd036fed6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4966f6c4f217ec162e167f57906f286a2b40745ce707587ae6c627a5f883d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb50f3d69f5262da65a47b6cf7c278ac0fba707adaf41a5c04fb62640c377d6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2397e58de33e30d05b6e16b1576373b40a6a9a679e10016fb0b4a808923e02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fddfa39a84f7ae7250e256afa9caa795bf3cd9f8ab5aef7cb9d9532293571e6f"
    sha256 cellar: :any_skip_relocation, ventura:       "3cf53d0aebdc0bf935bad431646db091d7bc67f31100e8a8e6a556062dbddee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4772da079f9b0105b4bf7d587916e8c32f34fbda67156c283087a9e48f65fb50"
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
    output = shell_output("#{bin}mago lint 2>&1", 1)
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end