class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/v0.5.2.tar.gz"
  sha256 "d70e17f7405c2c427ed2df7978797ca337668070d051087b466b460fa676c61e"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4860f64707da4aabb99a48b41b19026ace86a5ba0efe46775fa878af4c8071eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c483d4d9d01604204174e1526878ef68f65c304cbe27b67cbba204d669055e59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53faedc37ccb859b34461b287730b4369e132694a9049d659bb3a09f3b82a7f1"
    sha256 cellar: :any_skip_relocation, ventura:        "249592d9826745cc1d1b49e12b262ca6231699435c4ea80d65f21336fb005e31"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e36270f00996db358f45f511d5a7c490757162be058ad75bdeac07a731a6e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6ae06f42db7dda122bfea71271de9a7d8c9d76e43a50d4b97e4e7eb25732937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55cef70d7689cdb3f19f6f847ba340dc061ebcb20693d96d1d1f9f7d44cf4d8"
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