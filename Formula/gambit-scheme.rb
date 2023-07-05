class GambitScheme < Formula
  desc "Implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://ghproxy.com/https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0ce5b0842ac7f4a8ea7d152dbc3e4653f09e32f3a2c1a55120da16503d14dca9"
    sha256 arm64_monterey: "a3bcb614a53bdb5781297367986eb25e5b1b9fe335c8533176402afbf9840100"
    sha256 arm64_big_sur:  "86eaeb9637880c5bf3af4b787bbfd549ab266df66a64305078c3f44727335bed"
    sha256 ventura:        "cf1336b9082b23553b74ca6c341bbb27c2f102895ddf9fce92dd3a4e2d6281ff"
    sha256 monterey:       "8f8aa4a28c7f3af091ffa04e0a8777340de264558ccbeba2bd7a5e0fb72facd8"
    sha256 big_sur:        "7b742a1069e01c08c48f3fadf0b17b0aa905d5d34ef6273d6efc981d1b2d8a89"
    sha256 x86_64_linux:   "4b2e1e446240b775ce6bd32b59a265298757a137c627f9680a67dea3ef535819"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "gcc"
  end

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
      s.gsub! %r{/usr/local/opt/openssl(?!@1\.1)}, "/usr/local/opt/openssl@3"
      s.gsub! %r{/usr/local/opt/openssl(@\d(\.\d)?)?}, Formula["openssl@3"].opt_prefix
    end
    system "./config.status"

    system "make"
    ENV.deparallelize
    system "make", "install"
    elisp.install share/"emacs/site-lisp/gambit.el"
  end

  test do
    assert_equal "0123456789", shell_output("#{bin}/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end