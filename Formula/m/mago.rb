class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.46.0/source-code.tar.gz"
  sha256 "06ece51ad109d7e4feb0a2399b3e682c0f0a571c96a86733f0aeaadb3220c9d6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c829d04f70ca74d15f146536a7dbecffab23cb120982425b40dd6b294ddf71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67a8021556290dfc20bee6a2e099318dbafc97e74daac828e21ecd5e8646171c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b6800eeaefeceb5a5d032de7d8571455006f91e478ff1c62764373f03f420a"
    sha256 cellar: :any_skip_relocation, sonoma:        "67d2b4231e3341d836ab2342b1feb2dda3b79e98c87d39bed8ea1da5034a734e"
    sha256 cellar: :any,                 arm64_linux:   "119d55615acd9f5c6f94a8e47b1eb8b86ad771913193af9de370701eeb97f60f"
    sha256 cellar: :any,                 x86_64_linux:  "e9bf9aad4ab3a7a9944e6cd71b89db99b02f57b0bc928af1325b4b26fa752fa0"
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