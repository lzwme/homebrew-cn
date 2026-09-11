class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.48.0/source-code.tar.gz"
  sha256 "39dcfe5aa45c62594a4b8b0b35aacef14d073aed32f00326787c5e18c752a44d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f479d365acf96d16e4973efaddfe3ac87c3237bfe21225394704fffb0aba323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26bccddd801ab9b2e8738a6de8094a7a144f7495889a314d7e00f28bb7a10f02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4d11ce1fdc16b1ce484c5f3657e1afc09fd22dae7b0388e204cb716681f7b47"
    sha256 cellar: :any,                 arm64_linux:   "64bd1282ad0a5a6b5923ce62b203d376db82d9f8fbf5beef36067222b18a66ac"
    sha256 cellar: :any,                 x86_64_linux:  "21852d84fbd41a3b7c858d97ff58d760b129b44d90ad3e04d092e1256bb304fa"
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
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end