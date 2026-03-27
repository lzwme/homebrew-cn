class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.16.0/source-code.tar.gz"
  sha256 "3abe293415d0ca53068e62bf14c856ca6d900378eeea8aa1ac9d41faba930690"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b30ef712c9ab63692b937b11107015842c217a62ed38a96924228b6cfd91865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6347ab5b234ef84f9b4f9da7df87282cbd07373823423266cb381865f3ad7d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60acb1293027d995fea5234d51788fa58459c004af9fe031c7404c63426a33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ed7aa8273fc651c49df1bfac57fc8901501261414401bb66c33deb3481bfb17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6cad7899831a6decae0c252de685215f6d4231ce41cf9892e3a04ce4a09ff8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad9dfa8c4d0afa4714550878fc59e0ab2d7c28d5a8393c075cab798b86828a54"
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
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end