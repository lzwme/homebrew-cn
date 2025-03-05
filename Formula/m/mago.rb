class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.16.0.tar.gz"
  sha256 "419fb076c99931acd32ef9c2a01c66adb33a64d33e9d9ccab3b8342223904f65"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eb46c20290c4a1d6d91a4f7b55319fecede43b9b622a1a143936ae5748334ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ac9307b616e345072c5f5bad61ebde28716210c482a7bf62896b1f5baeee13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dfb4c75181754b52a9ccebd23e63996aa2a013a318c83023be0e30f119ca203"
    sha256 cellar: :any_skip_relocation, sonoma:        "01716fcc322e637c39d82d81011434b413fd17fcdec28698dd7e414998f3115c"
    sha256 cellar: :any_skip_relocation, ventura:       "239a8aa473322ed997137500116bd9b2a09ab37a2623d1fc4c8e1c13979fc575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46919fa92d26f59520d12639a719cdb5aba2fffad618858933ec536f4f0495de"
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