class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.5.1.tar.gz"
  sha256 "7058cbc70d9d155f36b7ef1253c2b506e0d94f2480cfbf7960572a875c007ae5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6c816b3121e677ec400393973c70361b9b3bf3005160b2f9b1f92bbfb84881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "846d72a41938b80487e4aa9f5f0880301a114c8818dea470ae0685222a2ec9cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f38c93314dda0ed58f8fa2be6addb308794d913b44fb911163f1533ed818a7de"
    sha256 cellar: :any_skip_relocation, sonoma:        "28e437d6c1839430e5fae9ea3b605864b12634a3ce29addd76b6783b1f9b8c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "9f86e4052b92aded4c48a89e887163020602775eb93c821a4b13a8fe6da74c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0623947a20aaac59bf24b0e87dba3730ecb4fc00b7203e3674aa3695c4e80af"
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