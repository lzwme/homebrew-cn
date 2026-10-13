class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.56.3/source-code.tar.gz"
  sha256 "7ab9b333bcdcfa2b665fb89bf9f95e64d1c812c6bcbb9b64df03de32e6b4879f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1000a215b4d052ca8479721bb9d6d10e7410c739b75f8a54586819da5a907692"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cd858dca0072e3212259eb0d1a76f19847152c6440d83784d606cad78f023fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ecd9e11f4a45f3a94cad40daaa2fde9a969d08d53ce0df711fedd435873e37cc"
    sha256 cellar: :any,                 arm64_linux:       "e4e3bfe94363baeeec7c9612009f5d9f94ff474feb5fe710d841a425e9e7d9bb"
    sha256 cellar: :any,                 x86_64_linux:      "c6b3322bd6db8f41291f2325e0c968544860e063edb7e9025e3347590a00463e"
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