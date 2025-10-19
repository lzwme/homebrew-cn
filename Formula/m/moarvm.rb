class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://ghfast.top/https://github.com/MoarVM/MoarVM/releases/download/2025.10/MoarVM-2025.10.tar.gz"
  sha256 "156fedfc5026174f516a076136e6065e17d0bdcf82061207ff1ca102b2cffcf5"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4a767368c57cd665dd4d63da099f166100bf9bb21b9dc194f4522240705d0889"
    sha256 arm64_sequoia: "eb6dca811108776ea5fda297cecc07712c922e2794d124f25ef923f32ee3344b"
    sha256 arm64_sonoma:  "19c0b927674c1baec5f7b8e2f5be62727811e49bc1d65012ed367c82a9e1a77b"
    sha256 sonoma:        "f3a47db03f17c0e8d8918b3085bffc0360729a5c564b7abfd365be203ca92970"
    sha256 arm64_linux:   "3d0a046e656f62dba56cd99c3fc2bdd41110e4b0a980321f9330c4cd4a8817e4"
    sha256 x86_64_linux:  "8d276211b9c3b53eeda8de2461bcd3898d4df5d7986a41e0423559b3b4053695"
  end

  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moor", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://ghfast.top/https://github.com/Raku/nqp/releases/download/2025.10/nqp-2025.10.tar.gz"
    sha256 "11a08aba5645b0b3a2f82d7f555632836ed1df2d710e92c938b55fbc96068a71"

    livecheck do
      formula "nqp"
    end
  end

  def install
    # Remove bundled libraries
    %w[dyncall libatomicops libtommath mimalloc].each { |dir| rm_r("3rdparty/#{dir}") }

    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-mimalloc
      --optimize
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
      --prefix=#{prefix}
    ]
    # FIXME: brew `libuv` causes runtime failures on Linux, e.g.
    # "Cannot find method 'made' on object of type NQPMu"
    if OS.mac?
      configure_args << "--has-libuv"
      rm_r("3rdparty/libuv")
    end

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