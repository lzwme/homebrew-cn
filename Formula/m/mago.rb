class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.11.0/source-code.tar.gz"
  sha256 "41404e3dde067fb06ae7b8f5f8eb0abe53f706c7978e5ae7177a8e8cdb18db73"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5ffd8d4c604264533a4cf3a9e1392e533d6bb24f31b7a438765172d0fd677ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84bc80614ec1c6d9f3335e48e1c4dd07e3d977a5c24d34af80cab8739745f586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de32a348dde150f379fa992ac1be779e851aecdd0c23bc59153c285b490634d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf1a477a179d6c545582e3692532e79069f5de8b2e7b59266f8271b801ff375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc5fbd72c396357a4a516ee247f2249ff066c9e2c2fd67d42afcd039f71b0a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c88037a74fd843696d7c9994c963450bea102e2eb1462df68490b97c27863c"
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