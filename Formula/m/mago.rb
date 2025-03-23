class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https:github.comcarthage-softwaremago"
  url "https:github.comcarthage-softwaremagoarchiverefstags0.21.0.tar.gz"
  sha256 "e807ff3504efd3a77dc0a4adb306d2b5c6ba77153dd163d57a1ac2e567ce2a1e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea2effda3cbd2e3eb353212193403c039720fd93cc4575c2e85b51ccf3e9e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a17772d1a5486a8888051ca419a394b2772366db950b3f634d4b130444f4c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6963e752176cdbb8864600dca959b86b319c440594841c63911676b7614f158"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ff8b5a11dfb499d90b9bede5d096a53145e891cf42658cbd440242d7350e0c9"
    sha256 cellar: :any_skip_relocation, ventura:       "140a60c408faab218fcfc4756af80c51a45b0c18c3aedc524e56c8f7dae91536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a0a947fd4e352289e4a26c6ec91dc5a849e0e44b1b29f7882f4cb3ce800597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98067042d7a82d1d812f7a0eaf6d532cf42d336b6def436ca0a164b6cbe59379"
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