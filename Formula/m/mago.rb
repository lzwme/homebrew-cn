class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.47.1/source-code.tar.gz"
  sha256 "cfc265c69d6926b4ec488fd16ce047cab4907691db284cf82d877ff562fad223"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ff9f49c0db317a018b0208b28fa92f8fc9c7b4812ffdca3399fe9cb0e10c909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdff56d49837bd2f6a942e493c11933fc55a51eb1b768b689d2fa835ba01dce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8c70a62a1d90679ff48afa481ca786c0d4c82025b7a76b7a92171a8049407ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebf047d199ba754f15966dee8bac28980c845f70b2a4c5eac14838d0febd4442"
    sha256 cellar: :any,                 arm64_linux:   "d2e3b6000d1bc69ffbe324b7dcd392b1396756045f164e021d60d632b6a1298f"
    sha256 cellar: :any,                 x86_64_linux:  "5519c8202e2328b8ce1bb5b4e3432b9d454b0f2a287ad2014a2547e21379aef6"
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