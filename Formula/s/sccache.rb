class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "7610667e53017f1d3e509e0be923608acfb85a6e77094b275e7b2db878aa3e3a"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "620cae601374b05f2797dc8001820f9b0a0bc8b6cc5691c236560d5b6b24650d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e549ae790b93f9b4158747cd430f80d2361b2b9dd2bcbf9be52c48356d3cbdd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f9c39bcebeb3d9e17fcf7368db49a5690d6f1ed51ac146b957874b6a36f5ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6de746425833dee72be6b57a5456d7603f2f9d821630ff2be747e13c3077d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "ddad6391131f69b9c26c661aa149f6ab8ccc9e4b998707515df5bd923c134e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "75dd013fae1821fe7d27cac0361d84ea6755b20c09bc958caab4eac16277c46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae5a3f3c494a325f489b1a4afda780ceac795c63803da6087df6893078c3087"
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