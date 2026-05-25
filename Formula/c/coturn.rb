class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://ghfast.top/https://github.com/coturn/coturn/archive/refs/tags/4.12.0.tar.gz"
  sha256 "8dc2d514f1a2beb7e2e609845d6ff37308f584fbc0e20e9d0797bb1f86d65aa6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "e5bf0298b58ac470850412176487feb0822693f959108886af24f5e1266e150d"
    sha256               arm64_sequoia: "df573589bac42dc53c94e8f3cc98effe599d7f88d17bbc632da300deefec2336"
    sha256               arm64_sonoma:  "c5b5bc32cda7c84d39e6bec27017a856cb6cc229daeb926214d56dde056d7d6c"
    sha256 cellar: :any, sonoma:        "a36985ef2b39d422d3cdda789b2a66b179aba752822cd06ca884d3c5ecc8c974"
    sha256               arm64_linux:   "8851d5e46d5b55511572d9fe08f3b72cd1bf5c401b7fd1a1bc92354ea02ab0ce"
    sha256               x86_64_linux:  "55fbf6388819a7cca70ecc297269d7dd4e188f5ff942e833c6046c250c870ffd"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    ENV["SSL_CFLAGS"] = "-I#{Formula["openssl@3"].opt_include}"
    ENV["SSL_LIBS"] = "-L#{Formula["openssl@3"].opt_lib} -lssl -lcrypto"
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