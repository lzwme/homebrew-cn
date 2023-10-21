class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://ghproxy.com/https://github.com/MoarVM/MoarVM/releases/download/2023.10/MoarVM-2023.10.tar.gz"
  sha256 "aa79d77896c312ba23e01074a53ef3d060becae2ed70b066f902f332da65a499"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "95a99de757e3a76c8416bd6ad4b8297ad48c3d538e5337aac60debeeb7071c2a"
    sha256 arm64_ventura:  "ec7d03be1269e16ba4c52e54afe78b318b8cd875ef1bdc6c52076b6ecfe71e91"
    sha256 arm64_monterey: "7af1a336ba51d98e3747713efe1b77a5d9ccaa7cd148fcf0d554f0af78d0ab45"
    sha256 sonoma:         "5b3b69be67d01e7aad792aeb4560e01ac15b85a44e056978d987c93ba31e7783"
    sha256 ventura:        "a4fca81f7b29ef60c35b19cf26b757f40acc675a67ae09fc41e30e892f6ce613"
    sha256 monterey:       "4c1826110ca94c2fbcfabdc114e4ad284f6111aff7fcd9a6a13976448555d567"
    sha256 x86_64_linux:   "03393e0e9924924a44be155ae59909ec946ddaae6b982df9ba61fb130b8844f9"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://ghproxy.com/https://github.com/Raku/nqp/releases/download/2023.10/nqp-2023.10.tar.gz"
    sha256 "41051246635db1d4de08d373e2515ab76280f5e0c57d4a4fa2426545ac40956d"
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