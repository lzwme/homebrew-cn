class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.1.0.tar.gz"
  sha256 "87657cb877840c53def1947dc98ef6801f873acd88780506deaa321d121a2c55"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c7a4ca1fab7df4c9cf5f198c8d1c81d7dc0a3d3a776b3760d2ef819808fb16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc794027df4bed8cf620362377b6f8640f1b766e3eaf54c3d9ac547b4c55d24e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60998aabb9edcb5cbc786263b17063a01f4b294f5271e4768577bfddf17e738c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f1063d636fb85dc6f022b4efb3baeaddaf1bf44aa007165ba36241a04f65c5"
    sha256 cellar: :any_skip_relocation, ventura:       "ddb2b2462f0a05f44f097fd6f08baba83bc922e7a25fe8b7e0be9f0bb1c88099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0528a08376114b4d1a090524fad4608a1ef7beccbe8c293fb91732437e0eaee8"
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