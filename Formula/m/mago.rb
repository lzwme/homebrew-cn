class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://ghfast.top/https://github.com/carthage-software/mago/releases/download/1.42.0/source-code.tar.gz"
  sha256 "f8422d900f253abd7738bb66a3855379c39f73569fd7d6dd774a28f757d082fb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ef4520fcd3234434b102938a67e9ce1811cbf63d8edc9c1e9a46f100277815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f4522e6c84aeb75d4a27fecfd9bf2a78b482e53c1911de6a5463dfe50819bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4263a710dceae8963a47fe18d4099ea934cd53ae276d3f2309024e01bd55644"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e2f383c2a25339bb8ca7e218c017af067ba59ccab5aad129a4a7425366e967a"
    sha256 cellar: :any,                 arm64_linux:   "45161bc9fcface4c3490c33a0851fb7fcfbd083fa48085ca738cbe2d3fcf4c4c"
    sha256 cellar: :any,                 x86_64_linux:  "e87d41f02f202ed5e6cd391fdb05a51ce5cac12013d6447e19990a4dd461d683"
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