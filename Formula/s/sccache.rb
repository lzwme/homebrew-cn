class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://ghfast.top/https://github.com/mozilla/sccache/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "eed7ba2b55f91511481df75e238307ac95885064fe734e0aab945654244ecec8"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3960ae92e6a32d5def85939442dd6a1270d7ca56d2d5f3955c2d7263f2dae000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e91e90319cdc0225a6538a2599f758e1d0093e55a17b1bd3c7f9abb809997e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac8fc0441bf7c0ed415f1c0a3c05518a96875fd56420401ef6e16af6355416d"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c6b1aa74aefd4944f496e1d4697d726bb8518cef5771da8a5b32924375bd8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a1067331f31871cf7bbeedab46e7b975a8861320b1677004330dbb92dca28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31777d4b283b1a8e7723b9a8e499740fe0b2c6171924bc7d03b29531d01b24d4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end