class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.2.2.tar.gz"
  sha256 "3935e4fb01a8f9f629ff624fe5ceb7616ef6336e56f1ebb4f7217b729624017b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bce6d1f37f8c8e068793f3727ca1205597b69902f8b35363c22d56852a282137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77bf0384e49a15e82c21ed19b77d8c2b568ff9aa4d03fe3755fc54729c5312f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "200076795bb8da21b484bbf9232b85bca6b48a52cc58633a850ab59f62249e30"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a57f474e1e8b2aa399920b04a670cb54ac9cd724cdebaca7b97d45a1abe3f62"
    sha256 cellar: :any_skip_relocation, ventura:       "ac962e6b1df004045055292891e74555187f78cc7f8810d68a80469a98d5ee31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ade277941e3f3f146f75a779ab4ffee1d84e3f3eca4c2e1b889fcb0d6da65ff"
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
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php echo 'Unformatted';\n", (testpath"unformatted.php").read
  end
end