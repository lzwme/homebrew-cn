class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.0.7.tar.gz"
  sha256 "b98936efc526c05071ae22abf9302daad3689bc41405e1bddaa2ea4df668ef28"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ebed36f9e7644056896d435d2827597096d3b8f15cd52496a6580119387da7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38ca5ebf9d3a1593bbf21a432ef76775fadd59c279cd5dc00da341b3a28bf761"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b685f719c632ec1a351ba8c99ef1c03994e79bf86e579835d2542228c0ec657"
    sha256 cellar: :any_skip_relocation, sonoma:        "f23ac62478f280d3008b4685fbb06186b9aff77eaa023ecb7d99a64df578ffe6"
    sha256 cellar: :any_skip_relocation, ventura:       "cc9a36d92f0acd7eac8614dd7985e8c143d374fb54d8884102c72338ab2ea881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbcb0b819b00a2745014aa9be1256fefbbf975bbb9779a8eccc43aeca6962395"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mago --version")

    (testpath"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}mago lint 2>&1")
    assert_match " missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin"mago", "fmt"
    assert_match "<?php\necho 'Unformatted';\n\n", (testpath"unformatted.php").read
  end
end