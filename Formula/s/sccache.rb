class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "15f3abf9031743baf7b2f0cb1567f08456795a52f49943793348b4b8c31dd066"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da683bb4facf62312fa28b91593154b2c727de0dc6ae8c40b2c8e0ce08b0d101"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8527eb50edf220fd9ef982870fed3576370a484c170645ba2d037b54f3db7a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd3ae9a48f602e0073c82a20361bf448d5df809e37dc219c2683c2483ed09786"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a5da2b37baf6e88a3987da5fe5dfb09f205d8e1e22645bd1bbf1950fcacd2b1"
    sha256 cellar: :any_skip_relocation, ventura:        "58495cd4d76c107f31836cf61d25cf054303c487e589b66b13f1cacb041c9dab"
    sha256 cellar: :any_skip_relocation, monterey:       "990a7067e9fa6d3ed31a1c32b4822d509d5fa84147a3ee67693ae3a1e89a05b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66332aa865dceb69609e252c85c53e5da5373e3c825b502a059b4f2cd1c0678"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end