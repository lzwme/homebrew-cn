class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https:github.commozillasccache"
  url "https:github.commozillasccachearchiverefstagsv0.7.5.tar.gz"
  sha256 "19034b64ff223f852256869b3e3fa901059ee90de2e4085bf2bfb5690b430325"
  license "Apache-2.0"
  head "https:github.commozillasccache.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27b8a9c47ac56b0701cac96e877a4f832ed2a4c0260fef29f3007ee17bdcf0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac1bc8460e9de4539cf763ed1eba323a223e12041290f84ccdd10419e332833c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08028f418edccedca4dc62e23bbd6e75e5e5dda9afa304501cd9233f2e273060"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f6ce7c9fb4b4637248da0effa39edf350cf9c4e514b54c104d8bdf23b15b77a"
    sha256 cellar: :any_skip_relocation, ventura:        "232aaa6586d388a0998647aece194e0a7d17d65d49c321098ab1859ce6e9acc2"
    sha256 cellar: :any_skip_relocation, monterey:       "fbf71131278a91c6700aa3fb7da6911c5242ee14f7365dd37b500612f8755674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8cb2d03239c2afccb72e1780aadc8c1ec517af521fab935adef6759b4b7322"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https:crates.iocratesopenssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output(".hello-c").chomp
  end
end