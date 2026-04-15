class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.20.0/source-code.tar.gz"
  sha256 "1c101523fcdd50b5ddd719161c02d9c62f23a19b944da6b157d5205ef3a77233"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e59a536a1c51a2c8651b5006549989926ec46380330ef665cf426cbee03447e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f7422cb57c9ab5e85b95f3169452c9a1d8d0d3c5f6d8d898898db2cfbe24c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879e67b32aff3a74cb64894f6299dcd8b8d1bc3c10fe1bef48d920fa314188d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "748615bb1f882b474d73dc4adaa627df354490938780a4aaed89757a48453cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6d97c2118bf8b821e1594523097cfb4d3983b13bd5112d7363463a640c8772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a330aaa06f20c2fdf33f56655f62eeb094b186a62150c7ef593afe3a326c6f7"
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