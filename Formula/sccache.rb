class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/v0.5.1.tar.gz"
  sha256 "cde142fb22575726de6d8348b609c1863e7c7afac1b7f09c186ee82cacc15191"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac62df3bf3f6f021171f28c4b1339954716f87e6781950e2e8b360b02bd5ecf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd511f57efd1b2b7b3df40ec8cd02571e26b605876238753dda626165725b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "345c1637ea445d7ddfeae84f69f58575f914caf49483bb66f369fb6630f55f7a"
    sha256 cellar: :any_skip_relocation, ventura:        "5a2b5ff3f9242173d319f9781f5bdd1be841a2074f135653eba63af30ae09bff"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c3989e8fda76929b06d9333260655331fbc16536dc61ece6512fcb0ea18001"
    sha256 cellar: :any_skip_relocation, big_sur:        "50fc7a9680a30dd2ae067007a56ba750771f6870613738c7e947514318269489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9619c73ba0de3eba54bb36580aceaafbf8bb323d08ac8ad25c9d828d6e77331b"
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