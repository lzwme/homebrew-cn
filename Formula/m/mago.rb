class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.8.0/source-code.tar.gz"
  sha256 "6335655525cca4ab04260553401911a70bacd2f017c3e8374fc6228cdbc9ba50"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce28e16dc95793d76c38c729427164f8858ed69227110c36dfc7fe1d714e28c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5040ccb33da9cb7756be568b054a739d31587c2139a09538ac9419582b054e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd6b29eda548d39899c0531e001ebef3e2e97a29f86c15ae74b17cc0358432a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a550526ea99f9387e585857d0c98f1bd639bd5af7b0129b1963362e0a933596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae3249af08131d74bb9fdb69bf8177f5febcfb039a7972087df03ad55ac313d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa4ba7076b1c83398bc57e0e4ef773cfbf4a12e25e591784d7a0328800ea35f"
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