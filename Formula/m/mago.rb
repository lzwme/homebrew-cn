class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.9.0/source-code.tar.gz"
  sha256 "0224e8bc90092c67027493fb1b25bdf6927314f790e3363e24c3f8eddd7fc903"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5311785103b629af214fe8580082b0dbb68d8397435b76d374d34ddd5b795e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303852fd62fe6e93dc465669d90293ecdebf8446d24f677866da05b7d10bb6ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6845fd16b32ae3fbd1bc6f9a13556f9b96ae63bb50491bc8114d5d7bf29d74e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c46b0a7e760359591b591d49a6b0287e6f80d37c8878d0a26ae4c36d33ac1ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6003d3f0ace61c389713291bee910ab5c7cffa5ded4474e316925c234ae8f08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fe393737024cb56e17fc62df9febcfa502277da91d6a98974e4d1f9fe89313"
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