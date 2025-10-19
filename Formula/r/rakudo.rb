class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://ghfast.top/https://github.com/rakudo/rakudo/releases/download/2025.10/rakudo-2025.10.tar.gz"
  sha256 "92201667468a9e0d5674c9a2f6a253f69fd058fe75451cd5c558b62c0c163b5d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1b4fc71038d5dc3bd17e4d4d919a3c7ca3365d5e1afa9c9417154e7ce663b69b"
    sha256 arm64_sequoia: "c840e55f5f99530e4337af0f04bfcde180b94c07284110857c388850f5f17b20"
    sha256 arm64_sonoma:  "55e90f4fdb13b1cb9a608a0ad86bc8d8211c4707895fddc88758c0b0e35d0ec0"
    sha256 sonoma:        "90a18032814063c4630024af563229a4be33d8f5a1cf386b397db5f1939b4670"
    sha256 arm64_linux:   "dc1a6e632d378c31def0747e00d0d6a28c75ee40d235d8249fe413c980d766c1"
    sha256 x86_64_linux:  "913e8aa6b0e5b8fab758f3c061dea131fcd64e9f14e428a78294369e9ea53da4"
  end

  depends_on "moarvm"
  depends_on "nqp"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"

    # Reduce overlinking on macOS
    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "M_LDFLAGS", "#{s.get_make_var("M_LDFLAGS")} -Wl,-dead_strip_dylibs"
      end
    end

    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end