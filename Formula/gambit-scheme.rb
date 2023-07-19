class GambitScheme < Formula
  desc "Implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://ghproxy.com/https://github.com/gambit/gambit/archive/v4.9.4.tar.gz"
  sha256 "19fb44a65b669234f6c0467cdc3dbe2e2c95a442f38e4638e7d89c90e247bd08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e33b55e30f8b151e9cd7465623310eadf07ba2ed1ba262bd1f70efd9613be5ed"
    sha256 arm64_monterey: "feceed5aa4a6f4d486722e23211017a8c9c040e2c0b6f28865458f543371c853"
    sha256 arm64_big_sur:  "56c42f91b17aae8bd28b9781fb7547a25b46d5d11893bde1346e32f0c5a73d22"
    sha256 ventura:        "5960f1a7442cc56055a5313bd7dea62978037702cb8934043f1ceaff989f971c"
    sha256 monterey:       "d1b794fc1a0c13ad38f672f63ee0af0702a390689ff183b9135d8e58207e7acd"
    sha256 big_sur:        "e0475ff6051b44a26930709b37cdc038f3aaea4b00c6622ccb24e64a668758a5"
    sha256 x86_64_linux:   "11b22d20fb8d65c1d36e2afec4fd8e69233072273740e3087435ebc643453d36"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "gcc"
  end

  conflicts_with "ghostscript", because: "both install `gsc` binary"

  # Clang is slower both for compiling and for running output binaries
  fails_with :clang

  def install
    args = %W[
      --prefix=#{prefix}
      --docdir=#{doc}
      --infodir=#{info}
      --enable-single-host
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
      --enable-gcc-opts
    ]

    system "./configure", *args

    # Fixed in gambit HEAD, but they haven't cut a release
    inreplace "config.status" do |s|
      s.gsub! %r{/usr/local/opt/openssl(@\d(\.\d)?)?}, Formula["openssl@3"].opt_prefix
    end
    system "./config.status"

    system "make"
    ENV.deparallelize
    system "make", "install"

    # fix lisp file install location
    elisp.install share/"emacs/site-lisp/gambit.el"
  end

  test do
    assert_equal "0123456789", shell_output("#{bin}/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end