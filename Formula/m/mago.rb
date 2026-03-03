class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.13.3/source-code.tar.gz"
  sha256 "d2f23d0cd129db9dac0b8ee029ddb37e94f7a013b89f5beed79c64f3cd52fbd7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ede483d27a3c8072158e4dd564502cffe8156624b10f0cc31ecabcf775f621dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ddfcf74f5cba63deefba04c99fb0eff15b13ea4240c61b306bb751eb00ebdd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca0cf04688ea0482b84d60323d024706d902cb6cecfba65420589d899fe44d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eb308e220bfbeffb5e2c516f996c7078283bfd65656fa3bcc022b7fb65fcde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7565aeced3e4f29fa27c947a39b13fab0f032935fae43de2f48e6c3e4d1e51e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30242f0e71cb06d4beb026ac70b21b6cd67b50d8cffe275b52fa47634c2d8158"
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