class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.57.0/source-code.tar.gz"
  sha256 "d6a2ceb516900051c65cdb25167fe3a0a5ef66386c32d5fd1991ea510d1a3924"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "493f81cdd4a829f44dacd01ce11d7dce4b6b880d5f86e1819c58f11754e60a73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6f620d5dd067534d969ea08ad6191e6b11cec33988d138c21b16719300caf4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6210cedd79489091e5d64a58e954bdf2a6d26f3c9bd9530968a9d396a26261d6"
    sha256 cellar: :any,                 arm64_linux:       "d72ba3ae16e4bbfbfecd55223297002fb98c8f7cd9720dfb889377828d3cff18"
    sha256 cellar: :any,                 x86_64_linux:      "5afbc9b966f3309d68ac62776e353964455c9af73c68adca4fc81ae4e6721d45"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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