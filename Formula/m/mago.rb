class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.14.tar.gz"
  sha256 "d7ee5a0afeb62007ae759a35f723ffe01f5455f8836cf0300e7a67b97074e7df"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ba72e39f4fd84ac953c33d0eecda6f9202b0af675c8b1a50f518d14557aebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ddfb3e202d44546af28e328eaa0189bddf74617eb6566d8f73f53a6ae2ddd96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3136eec6489ccc0cb328664cc94fb95f81bbf06287fcb00c6d8aeb4fc915a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "23362cebee3740f69cc57511b04acc5c310e554e28970f45930bf48f5398b7d4"
    sha256 cellar: :any_skip_relocation, ventura:       "18a69ef933dd2eee39b1fc026e4832ab94d84c002826481dfee23603227e1530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df14d75e998d0d0f41958ddd6675ad30c9f07a47e7f2e1445e5a5c4685d9e5e6"
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