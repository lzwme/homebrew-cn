class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.47.5/source-code.tar.gz"
  sha256 "5e5ad69284aa8655309e29f95b5de03169340198900b4722226deec98787469c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d84850f01a61b6f27374a4a7dea7cf5a906e297c2584f276f4dfb3f5edce5dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7763ad421bf318e0760433225c2dc20308e96ba9b75ea597bfddf8598bfa0115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9571c218502c3e4f96012c0fdf6527ebda7a146d5ccfb13d8b330bf877922da"
    sha256 cellar: :any,                 arm64_linux:   "e15ecefb51f32ee6bd0cfffcc69298eb0bed5b29b7774e748416d7284e15f40d"
    sha256 cellar: :any,                 x86_64_linux:  "b6b36c543f888b346164d0612f23e19481eecd9cf42230f2e3cbb59813265bda"
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
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end