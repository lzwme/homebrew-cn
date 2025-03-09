class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.18.1.tar.gz"
  sha256 "e4ec2dd659931adce31867676eb89ee6258b9c19bee5522417591bc1c8d7c64d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48804d2d652e82f044fccdb199b7ed08322f1fe4d4454e30927a4a973e4543db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b0a81fb04aa6b3ecae0c0eb9c82afb314ba8ba5e80516c2f146d84c84e11283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5dd825a5b734d3ee14bb98c90c62cbe8fac7a1a72d378eb99f4fccbe78f9acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff2b1e4843dc471b6540b5024455efc5bd5c3562f51e964cbf296e8d481b3aeb"
    sha256 cellar: :any_skip_relocation, ventura:       "529dc93afae5f47b56590a869948c30b10e6d12a5997a1df3d36c0b30d528fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc93fef7c1c7c25be19bf6e7cff2cd8c4e5790e7f98e96665001d949f7f575ef"
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