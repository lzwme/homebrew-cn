class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.14.0/source-code.tar.gz"
  sha256 "38551e0531d081d63fa6e971a001f48ec7cd0d0fba81bec4f63926a03af1d002"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a7a977ac55b472d7226781ff404d6bc2eea8202d6687adf58a3bdbe8e86205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2326fdc4f3ce0279b341bccd55a33c4feebe497b82c5e7b309b46a9cecfe173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f05eae3f2bb771ac375f9fcc838a0420eac0dfa2dad2a0e2d73160347a8420af"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb550718fe12b04fb7725eb9fec45cf5830245c1581c016830c412d6682262c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2e335b68a4a07e14a4c19ac31df9b4e04b7d0dea0d0d327ad77c94a569371bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a217b7882ff62286933c4cce87c346ae1e5180f6fbbae856ba66948e40ec606"
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