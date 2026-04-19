class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.22.0/source-code.tar.gz"
  sha256 "a644f3f633a1cc7c1cbf6bdeec4d8a6bd7e6088e9269b8b40201c644e2b94665"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "691c1a839b44936b9257f6fa5d1d0958c5f15c90a2759977201ea1ef43562a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d9715e4b48739e437eecd8eb80f3ceed1d4a2989bc80042b7b671a85aab408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b25f42478b13ca9e8a45bb476ddc409cdd922ec558873cb5c50766d158d3f61"
    sha256 cellar: :any_skip_relocation, sonoma:        "e94e6d2941a3048e4609dc8d551d465630156f086d442d70f6b544a2dc2197b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff23ac3f7bf8b6f745da6625f10cb7b98c78f51ebc46be7f0d8df39ef54f5dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690c3e5175f8805756a632ca5e999ede6bcba57aa022914679d26e8648c9fddc"
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