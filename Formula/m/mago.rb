class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.13.1.tar.gz"
  sha256 "14ece8f95ba80156a00938deda69bd36067bf7732772fbc4bc0687274ef38485"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d39f4a1ecb4785bc41a159c5507afdc3285f906d5b01bce6384af12cd74eda5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95173fb5c53993575e7229339a6201fcfce1bcfe769d144f9b4f8538d2826cb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46ad6e082ac20259e7a3a82e8898813a2938fb1fb0ec75f36b750cb4d46a2261"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e2c861e0ae3c07c95dd144a89eba393f7fbfd49b4a89ef813c9cd99e058bad"
    sha256 cellar: :any_skip_relocation, ventura:       "b1cb3125059726777896521da7d508880de27f6d643fa4a31d8796f4be0740ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a664d52bb5e1f248b751b8bd804218e7c2053596df98045b8cd3dbb4963eb8f"
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