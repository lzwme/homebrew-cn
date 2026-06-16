class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://ghfast.top/https://github.com/coturn/coturn/archive/refs/tags/4.13.1.tar.gz"
  sha256 "c8f8db0e2d2d04d20535b2c928f9792ed5aa8cfd0af34f323a61749b2c7baba6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "6ecc663901ce25f27ca800f9492c63c160451101cdd15a9c0a2aec3470ee5bfc"
    sha256               arm64_sequoia: "45277bd234e75d51d167ab5cc88b08b0a6427fbe694ec4418474c81346280bb1"
    sha256               arm64_sonoma:  "ceafc629beb932a88cfa2ea3ee7ee5a92a5622f93a616f1be12f5b5617958ce7"
    sha256 cellar: :any, sonoma:        "edfe9f050f53936144ff6783c739b86baae24211d6a44051ff20e957af61a08a"
    sha256               arm64_linux:   "5cb93ad5cb9c15899c0d90b9e26ddc4a247dfb456678823eede5fb0222c1b012"
    sha256               x86_64_linux:  "933d68d617d5c4d13c2e98de0cd89bdc11b0f94762ceaf0d060df198e4413a95"
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