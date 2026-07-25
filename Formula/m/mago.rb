class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.45.0/source-code.tar.gz"
  sha256 "eb97d09cde4e91df1ce631f46bd0de5ec2d861bf2b35c7db569e97ddb62f9096"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69f4aeb9bc7bab5a24a252cd38110f46ff7ce2e6ac0560a2a8a3921065d8cbfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046b8fb35323b1bb60de72c2ae6dd2dddbc6000de6221695272dba6b38ac6af1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b01022e612126569c6aa5a0fe2173c029fe5b0b9e19223044abffc4b7f789d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "17d7d4ecdff7e2ad80a93657fd2190b34db6de9938e69a5462f1071ee3404921"
    sha256 cellar: :any,                 arm64_linux:   "0165d053c7cacbea59fd7cc4de675b8212287604a14c114747c36f988023b459"
    sha256 cellar: :any,                 x86_64_linux:  "419d2b3e65300151e4b844bbf960addb8141b40f6177c3b69232fc5974d369d0"
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