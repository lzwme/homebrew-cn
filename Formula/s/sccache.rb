class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ffa687a872f590ba0bfeacb54ef16f25f78426207614681f85b183fabe515400"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01e9a3d6b04b826d16b549c9d177cf64561c75a62219f729b0e46d49e8b42213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b8192801ef18414df474f455fe02eda7c102e9f1ee359fa90014817c3c455f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bbd6ef6eb9e0a42ee33abf0dbcf9eb48449c68128e6f377e70b3b2869adf8ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d1ab593f608ede5fe1de269196b4439cb3c7b7f55430ece1e5f8272e028224a"
    sha256 cellar: :any_skip_relocation, ventura:        "e02e986df67fe878319ae337584e823d93f0478200b25ac72ed264bdeec0d381"
    sha256 cellar: :any_skip_relocation, monterey:       "8b5471e8ecab4a34e960156a93aaa59fbd0a26571e5b990a7e20998bdedd598b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "318e2dd24fb829a2c494d2c21c58e44eadefcf867dca2828c653564170c0c321"
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