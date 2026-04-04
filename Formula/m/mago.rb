class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.18.1/source-code.tar.gz"
  sha256 "4e5f4b862c924123c8f138d2041920a7f1b5929e406623d4f12d6aec17b52cea"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0491d89ef510427bef77c0e2582f70ef123e668751aadafbc0be19b4f8c1898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c94905064617130030f08590c2196a652ec9f8017850ae3c0b9f1dd53b35a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a1cc356ef2fa2bdb932982f7c832534408301da2dfdc393fc1f2ee4cd498101"
    sha256 cellar: :any_skip_relocation, sonoma:        "411b46ff4536242ddd817038dc38abec997a63b1c8f4f09f5add1fcffeddd4fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79b26b23d86059e9f1d3acd5d8e3cfcdc81dd6c8e9e557d033845e9f063b58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909d1c36e30bf9777dad8b668c7a4be5145c64f4dae115df049077d02ae50a62"
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