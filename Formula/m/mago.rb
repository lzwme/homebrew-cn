class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.16.tar.gz"
  sha256 "e974240f040010fa3bd7d6182797a2c19806918ec26e8236739035643ed263bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de47e7fa48f4233b26ca5a7c45d446f22b7d360086adb5ef9d0f61f7325fa433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640a34306dc14bae474ab921e4b8ec8cd8bf5a29634bc4a175470df3598c73c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c4717c066e14c35a97faee7dd8f52b660485f690a6cf5f895dc445affc61c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "00763e98af9d0d130b1e68cb9ec79493cdd436396aa6f6799e7bad6de1094eaf"
    sha256 cellar: :any_skip_relocation, ventura:       "8d8811bb60b580b93914e035cd07a5107114987b5efb8d1cd08bd612cffba662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2014be6ee20ea52c4e24fb7d0e26c54bd569ad0630e740fac0b5da6cf547f60"
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