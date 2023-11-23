class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://ghproxy.com/https://github.com/MoarVM/MoarVM/releases/download/2023.11/MoarVM-2023.11.tar.gz"
  sha256 "32f4b100dcdb7f4bbe8575fca0eea4b7b271f177c701138a8f58418352bdd103"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c8315a28a4cd938234954a94398617429c18d98a23da13a96490c01ed8cb01f8"
    sha256 arm64_ventura:  "97e776293ded21c74f4ee0c49ca4d30304e344eb154ad1c421c05b5ade641f9d"
    sha256 arm64_monterey: "413d433df0a25ca1668c9b2ea93f31595901d2dccbf203eca73c6b53353afe22"
    sha256 sonoma:         "fc0bd2a41b564c1fac99c5b742db9908ca6b904b1f375cbc51e957b765bbe247"
    sha256 ventura:        "321f54b2f7a3b9147b825018939b659d2d026d0e1fbabbc3f45260cc7563d056"
    sha256 monterey:       "a81d946c37da3683a0e51401fd69fdbb8bbfc7d30f11b6d131858e9f42ce14af"
    sha256 x86_64_linux:   "feb6247264940af49a5f071f7e029367989a90d5f6cc5af7f3ad7f6177b20d7f"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://ghproxy.com/https://github.com/Raku/nqp/releases/download/2023.11/nqp-2023.11.tar.gz"
    sha256 "e7176b1a6fbaa98c132e385f325c6211ff9f93c0a3f0a23ceb6ffe823747b297"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkg-config"].opt_bin}/pkg-config
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end