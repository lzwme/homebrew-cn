class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.12.1/source-code.tar.gz"
  sha256 "270c643c228787f733eb62bb82d67b637b825c22c0cf7720dd73b80601885def"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa6c8b99c499ad9ff2c5c57c366a0061a5edf30a4006c40c2db270b98ea17061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba6f5eb00f1e5a0fc6db219705775a6dd440ecb297a46bf270f119eeeb88c881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c258062d251676ec347966d997229ba988a0f59a1925f7b30595eed7ddb1e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4855dae0c1e1005568adc31a6e243408bdb29b2258181bbbffe38a85585a4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3733d385b7b7d369fd37ca4c4e446f889767bbeb4048e63326e87f4f8f7352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311b13a3a498045d8a6679f23562153b1fa156ed842525b3b7f8a18f379c7a74"
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