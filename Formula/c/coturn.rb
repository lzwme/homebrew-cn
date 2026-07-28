class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://ghfast.top/https://github.com/coturn/coturn/archive/refs/tags/4.16.0.tar.gz"
  sha256 "4782c1560c2dfa4697dd3fbd85f2f8b506beb48f1d738351464300ef1e294760"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "ef30be969b22d2eeaafe4846a97aa0f8bd1445544e379fc96a7673458cc53129"
    sha256               arm64_sequoia: "927bbc7b063e7025978c2310ab4f5416eed17c924156f5d3a1acf200a3922712"
    sha256               arm64_sonoma:  "03aa3bade281a2d1f0abcf581fa3b1ca9bb2256955f9efaff6387fef216dd078"
    sha256 cellar: :any, sonoma:        "46cbe24e4dabd56bf74f3ba79599aeb176939c41b6dfcaae7ea27e812231970b"
    sha256               arm64_linux:   "117312d9e908fb79a4a6ec2a7c7386fd32631201abd33c858d6b60d579080157"
    sha256               x86_64_linux:  "38637d807c96d51923d25730a6ba699b03edba80da0b1632712460b2c0caca76"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    ENV["SSL_CFLAGS"] = "-I#{formula_opt_include("openssl@3")}"
    ENV["SSL_LIBS"] = "-L#{formula_opt_lib("openssl@3")} -lssl -lcrypto"
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--docdir=#{doc}",
                          *std_configure_args

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  service do
    run [opt_bin/"turnserver", "-c", etc/"turnserver.conf"]
    keep_alive true
    error_log_path var/"log/coturn.log"
    log_path var/"log/coturn.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"turnadmin", "-l"
  end
end