class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.13.1/source-code.tar.gz"
  sha256 "a98429f9c45cfc12f8d1329e35a4044e6d9d290591d6f5b2586697e40c81971a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45d975993a408e92a5dc370ba089a65eab3cca4c644675f70222c69624ef9ef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f3fd33d1d3caccabc819c236bcd196091ea1980c7682a171ac1949b9bd5ad99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a7b9a611fd701c1aafde166291bb6c58d955085f8a4d9de2e449ed6ad56fc1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "055362a7ca984cdde7c4041b71f76bb9c6213309069197fc7f0d666a21192506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8732f26f415be1897809e21c60626d2bb0e44cf9007222cd2b055e7b65fc1b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe5d71e183352a98d10970662c5c914b06ea933bc90f6ba94d0b698b9b7e28e2"
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