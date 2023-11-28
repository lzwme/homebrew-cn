class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghproxy.com/https://github.com/mozilla/sccache/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "32301f125d5b1d73830b163fd15fe9b5c22cf4a4a6b835d893dec563aba5b4fc"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "334087805acdeac14682273d2d09e2a54493b8d7f5bccd1bcf33c23f341468b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b474be161807d49cd3c2a08438bc4cc4b99bcb29e129157395ab9bae62b946db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2c950f593c0dbe1ad5835b175a1ae9c21d5e85c99ce243286a074526805e8e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d5af02079156e22ce149ed287fef2253f6acc08b4aa197de2d491ac15e44101"
    sha256 cellar: :any_skip_relocation, ventura:        "7400d8482d24ce3b90b3d82d0792c8d4be02b91252e7a39be30fc8a9b77546b9"
    sha256 cellar: :any_skip_relocation, monterey:       "2398c0375c5c282810ff42b90d44dbdf56fb955c0c7ccfc980fd5bb2c0c8fbb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc291fc28cb35ad2c2442882a6d2f7276d5e205394215aae672d1d5e23728dc4"
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