class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https:moarvm.org"
  url "https:github.comMoarVMMoarVMreleasesdownload2024.06MoarVM-2024.06.tar.gz"
  sha256 "24ecedd1220e215742cbfa9228797812f6f281ba87bf5dc58e8caac0c0d404d0"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "71d6d92eceff4fed104445f084f7cd6ef7dab4b2ef46a60b14cb3f83518f5fbc"
    sha256 arm64_ventura:  "5cf5c92207144e9cfabbfbbae7ac3ee09c6c80ea2eb2ce7add612a21d7d5d903"
    sha256 arm64_monterey: "b8f210aa4d637133ee8d879e5346dbe7544ae5868bdb978e5bc3a986bdf7c76e"
    sha256 sonoma:         "6e104dd7db5eeb6ff9a8892bb892559253fd7630591a1b147479791d7b70acf8"
    sha256 ventura:        "8ee7fd2d69c204b93fb1b8dc6ec42d2dedb50b5d6534982c35eb6888a94d4a56"
    sha256 monterey:       "b5025ef28f86295ae4d9162a9c578b52da04a44bbab594f4b01e111184a98201"
    sha256 x86_64_linux:   "e34f3a8376cc6813a6e42e45f5b4e475961d6f34c6b81c8674ccff7a596afe7a"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https:github.comRakunqpreleasesdownload2024.06nqp-2024.06.tar.gz"
    sha256 "0af0bd5a70aed446ffd246f2d354d88181e555aa6de826f1c40d76ab416bfa94"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkg-config"].opt_bin}pkg-config
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("srcvmmoarstage0") do
      shell_output("#{bin}moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end