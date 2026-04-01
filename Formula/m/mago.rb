class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.17.0/source-code.tar.gz"
  sha256 "ccb6289f544116268be1fe9a7e6088ae085b46144504bf0040c6288c23750c71"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "071657cc162d2f2c07d457b3ae882854b48adecc2956887d2d762887acdea347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f45dfe8a923c35d1aa44b89403f5f244682de3b987878477822d93e808e021c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ee891b586fa9e02bffaca1ce705ebec8595d994e9b70b776c091c04878b4b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17f1e1e0daee508ba4ad4c3304a94cba671b5735a7030ca9e7d878b8fb5b950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1fbb139bb26bb5b4067b41eb64809de661ce15622159168f9057fbe73c04ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6fc2cac791a1952609b09826c61e8699a80c50a190d1af72764572f15f875b"
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