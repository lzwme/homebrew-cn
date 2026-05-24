class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.29.0/source-code.tar.gz"
  sha256 "f131969febcda717b5782d19d4b1b9ef9ed559a5c8803418b41138cbb58f3615"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9551a7a5a22b1083e56845e864faba0753dff5ac82f10380a6d5ec75b311313e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b450b1d2d8fed81bedb789e7c2ef36b88f66ef2ed489f183cf20e7570fa53f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59212f5a7d8e6391f925c2abfd34f5549ea5ea7a9c3886afa0aad96cb7d29553"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddc95ec034951bb9175c93d5b001a2896db071375f3f0775ed77d24496e1095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d58c4cf84c8f398118177c9af73082eec5ea2b206903136337cc08a0a45dcf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7b2288ca7e59dd60c00b7f55ece1e889ac66dade29c74bbd1db1ba34c73020a"
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