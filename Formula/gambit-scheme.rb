class GambitScheme < Formula
  desc "Implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://ghproxy.com/https://github.com/gambit/gambit/archive/v4.9.5.tar.gz"
  sha256 "758da7b4afe6411e9c4fed14b0cc5ada39b5f1393c1edd4d3dd9c9a06127c310"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "958094368433dfd957d53e1cfbaa8af1235b879b70ace4eea23bbb1196f1aa5f"
    sha256 arm64_monterey: "12263d69bdfd8b2a13901ec6967ba60946e36db1e0fff53190a1e27a7ae25221"
    sha256 arm64_big_sur:  "4b8892cf54da88e4b8edd58e31d46a6c56fad15b3f5a2dc646e94958db044ae5"
    sha256 ventura:        "7f26f3c29562f4dc3c8033a18e53d47bf55c093dcafd622e8fd78cf4d8d61f28"
    sha256 monterey:       "3ead39c88a5246f0f8ecbb1afa4e4dc218375c35aea624afea101c7b803321dc"
    sha256 big_sur:        "1e335b312ef44ae5d0b3475ab771da5390943a33435883570cb124d11c9c02e7"
    sha256 x86_64_linux:   "5c4bb1bcc575d1079679114fec7776b3ac881ce67324a1a5b0bab2b6843f7ef6"
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