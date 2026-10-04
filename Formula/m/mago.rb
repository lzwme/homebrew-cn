class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.51.2/source-code.tar.gz"
  sha256 "11ba57900d7e71ced232c17924466e0c2cede1b2b37f70538bba637aa2fb99c7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d81f6b0e2dde62032c2402b6167045400e087de140079c430afa269f4d00673"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c2932c258f2ba0cc561c273d3d2ebc715167eb27f533bdf7a4a99e9c1e73980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c09899143aa603d9cd097500d9312e0555aa8bd89dcf6310642be3ea9d3ee13b"
    sha256 cellar: :any,                 arm64_linux:       "2306783beb75606e7343da5513a69fd282b2a3eb897016d12e3f6fc0f4105800"
    sha256 cellar: :any,                 x86_64_linux:      "4a2c4a53bdc8f023c8743c4eb7643bce9fcaf2313113db7917d666c142c670f0"
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