class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.48.1/source-code.tar.gz"
  sha256 "a32e31e024be1d77b4ecb6677921405777497e4dfbc9263b8f61745993849c9f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fa6534c5aed2f2578ac112be8ccf99de3fc467cf04813c06f9047d1ab758110"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22f97c4d4e46dd18231db6a4276ed712a5fd2f7726d7bb82874a7b9e8736d600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4bfe4f66b035094f8c025ed46157d8c385c5d86b94e15d3fd32bc28acd76d841"
    sha256 cellar: :any,                 arm64_linux:       "9d11fd5874c6adfde7a426d96be52d5c089e75d8cf3f9b5adc6eb0c03384ace4"
    sha256 cellar: :any,                 x86_64_linux:      "2515f5d79fab3593d6d766fdd5fe53021cc06d4f55460c2686352d33d1c1230f"
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