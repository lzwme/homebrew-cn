class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.2.2.crate"
  sha256 "bc85a36812e1a8f89865d96bf90b53d5b2be693fa3eaefa6d876aa12126c0c52"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dacab803f29f58f413be49ac4e44d5320462a91efe05c17ee4d2ff2dc20ae06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7766ec901f97753253ad4fd7637c51307ab5e8dc9892bdedd47850135db4ac9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b4043afc3e781d75217b08a8fbf2999acc241ebc831b77e9f858242774c692"
    sha256 cellar: :any_skip_relocation, sonoma:        "21aabcba081ffa887dcd83831fdb220a936d843f7333bf4cdcc9e945767a0935"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7008df84dd161bd55a0fd878a8c8a02ddbf5435cafff88acbb4aec153d70e3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd1d469a609700972b519180b9804663daf5a1683bc636c66cba0a5ec191c90"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end