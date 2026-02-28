class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.13.2/source-code.tar.gz"
  sha256 "ab1d2e62d8e091955203b2ee4d03f1b27421eb0ae2032443b9cdadbb85ac811a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27e4cebe9ad1d7f6f73ac158bafdada89225ef4ffa640eb5f3c75614abeb434a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81ae7b157cc02a12d970f2693ed090019ac403670129c9873d7516d84acc9d23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60cff6efda6b10dafee8e661c65a2a29a875d691bdca58fbc800afa44f541347"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d2b6c048e7d3de28b3e3bcb660b1574cf372619d1a5518418c3bbf792e921d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd031c9a4b759a9a8ce980ec4cb5b2e6690adc40f1a5bdeee1aa8940cbfb5580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b64d2efb28698670883fba667c8769fd211ec398f387c3ecdf36c4674cf0dc"
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