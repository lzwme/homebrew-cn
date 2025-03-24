class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.22.0.tar.gz"
  sha256 "d9ab124ec42f0abed1cffbd3c9dee4b97170d661d3c91e1d4c4ebc4a85db48ce"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bfea920d38ff0f465df385b24c860617a79f4761a5294aa01390734372b3ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0097754ecad2deaa9dd9298a7537a4e849ac821b521bfdb1d664c3df2796fd90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c66a79f7c1417c75d4bb962cbc249ef9623731f27702aa2916a97c33a47338f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "10786f299545e7fe71eaa78921dc902d2fe62ac1b907bedd3c59c2171ae59e57"
    sha256 cellar: :any_skip_relocation, ventura:       "75a9aa45ec506aefdb5844fb1f037599ef1abd886294734a747518c06e6b6b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ef988f5d6e4f0561670dd2b8a515fbfb04cdf54e4b6f749111d731d403cf0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "995f57b6182ed2084528949f94ee3d8c36be8110d3209626d7db2a42f316113a"
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