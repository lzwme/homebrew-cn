class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https:moarvm.org"
  url "https:github.comMoarVMMoarVMreleasesdownload2024.08MoarVM-2024.08.tar.gz"
  sha256 "e438ed69854ae2ab5213bd6d41e6a08c1ae14c2d7a5577fea1250f86784bf74b"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia:  "0c6455820896a97aac53d6c666cd69199bdbf6cc2fe5915f7586834c77e311bd"
    sha256 arm64_sonoma:   "383612941f0990e5e379880b4a75fa61fef3d5181f7e661a1c07665e21437dbd"
    sha256 arm64_ventura:  "82c13996dd26b2f3b1085375fc33f03dec38d7fd4f139ab4f73556c344cc690a"
    sha256 arm64_monterey: "0b188acf40dad6c1ce1a78cc5603ede0a4da7f414b9241180ca483f98f3db65e"
    sha256 sonoma:         "38f811ef661ded6243ef263be1ee5ea700e3016ea8d0edf55f8499124f73bcf7"
    sha256 ventura:        "29b691440ef0a86f7a86687d802fdb3aa34ffdcb8136ae0f64fc02ef8710a4bf"
    sha256 monterey:       "93383a14d6e4deeda5225de8b00afa85add0a463587c68b8d3c299d717430f19"
    sha256 x86_64_linux:   "654e7a52b998c22cba01046af8cc78b20561d0758886535568586b6fa6a1267b"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https:github.comRakunqpreleasesdownload2024.08nqp-2024.08.tar.gz"
    sha256 "6b9835ee5c0aa9e561cc7cecc846fe496ffe432567407bf0c3c14c3f3a2711a0"
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