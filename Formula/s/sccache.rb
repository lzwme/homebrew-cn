class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5807417adbb120531ed5d7a18d5406e736be99b45ce9239ab196473fb405e62d"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "106b935859005bdf1a6a7f38def4f6c052ae4c9ca141a8c29032cab90db3fe15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2924708d317b72760d136908af6dd90ffa3f14b4d3a9129c241ca0673d9bd085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7096dc4d22727d10a9f5d3a3c0659beb0a729f6bfff2788da5075d394cb36cbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2e563bf8d739e8d2acdcf5b724d39a8ad09a619425b0b0ba5c5b3a445a269ca"
    sha256 cellar: :any_skip_relocation, ventura:        "eca9d911ad602d56618c996996d1af361caa6604e8bc83887d85369e2df08f37"
    sha256 cellar: :any_skip_relocation, monterey:       "684393757fcfee64c219507f9d0d2be9bbc301c12ad5908d4b024158f61a5b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c7701eba2c56472a7ed387413ab423a809c8b28b4c896a1c99148642609130"
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