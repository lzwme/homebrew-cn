class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.6.2.tar.gz"
  sha256 "4975744908a83c976ad56fc0755435f651c7e47124e0eb15e862fdd922fa8e24"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c01689bb3e418c2ae6bdadf14e304ed122218aa7c400c0af3687f21e3d455ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e762384c582a900fb4350b1bf397e3d79054f23c5044b5e1ffc76b98b4f96974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2872a3664e1eb6a3c7cd5974a10d2773b3af53f5d80e161c7aece0548f39aa79"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c06cf483030e0d3b4def8dab4c9fbaea763851d24997db0e26854ad6d631b5"
    sha256 cellar: :any_skip_relocation, ventura:       "9412083606c781471f6e9d31f40cddccd5e0e8f88a56951d2fe0e291d9861fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41829b38427ab332e3eb597b483c13e59df50303cab27d55e11b7fc2e9d44622"
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