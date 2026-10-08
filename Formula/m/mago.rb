class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.53.0/source-code.tar.gz"
  sha256 "04a926bf3c9319cd96852c0753c8d04844f8195082e1eec98bd385c47a621185"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc85c19cbb180255b36b41f05a2f57925bf2bc81e4720ac9ba1ccc139921df78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b10f59e33da631deea1ac0c3b64178001659618d6d31d4e04bcae294e3372060"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f32b75c71967eb5f09248b374c6c70477d9896f6be85f674ba439d337f4ff2ad"
    sha256 cellar: :any,                 arm64_linux:       "54295ce2502f1fd2aa357f97d643a361d010bb61536f6eb53475ed168f6aa18e"
    sha256 cellar: :any,                 x86_64_linux:      "3c650c03a5bb0d6de2dc64af8533e961e672002919f8cacc36cb027869c2f1e5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end