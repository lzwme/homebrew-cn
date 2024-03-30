class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https:moarvm.org"
  url "https:github.comMoarVMMoarVMreleasesdownload2024.03MoarVM-2024.03.tar.gz"
  sha256 "d6185e22d05df7ddc38b4b53fb50bde318f074c7517c849b5411642753f7ac24"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "e1ffbec8e95c4ec48f4b45d5ba1cd39ccb1ce9ab2f78b8798b4dbc4538b4955f"
    sha256 arm64_ventura:  "0fab08d25bdb859c10897ae8206e132b79904a386715e9200ebfa92e95293628"
    sha256 arm64_monterey: "0652964e290512d8f26661e6f5931227ae4b1c292e283ad44350b17aeb40e0e2"
    sha256 sonoma:         "ed38b852f13c40e0ed31e8782f57b8d6f9fd5760656df58d3c8ca12c2bb76d7c"
    sha256 ventura:        "cbb74bc61d9cd398c797039dba613f889e7088a0bf283b2c708efe9945c3b0cf"
    sha256 monterey:       "abdf8b5bcaaec7ffb6d94fbec1dd049ef893d958cbb0b6ac0ca93acf0689afea"
    sha256 x86_64_linux:   "0dab05f7b7170f4510c9a99a58e3eb8ab73258267ef5f178254e6e4f45fbcbb5"
  end

  depends_on "pkg-config" => :build
  depends_on "libtommath"
  depends_on "libuv"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https:github.comRakunqpreleasesdownload2024.03nqp-2024.03.tar.gz"
    sha256 "5f642ee1a4597b758a6d1170464cc0a27f1216b21624790bf053f1c86bbfe0b1"
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