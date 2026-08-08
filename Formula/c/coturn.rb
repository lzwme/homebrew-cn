class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://ghfast.top/https://github.com/coturn/coturn/archive/refs/tags/4.17.1.tar.gz"
  sha256 "4e1a995c04ae3f34ce520559495198e07154dff0964e8e7034ff09d414c0e7cb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "c6893363badda5642cd0a6ea8bbf7fc9d1dfe5b07fd5daec77d9aa00e80035f2"
    sha256               arm64_sequoia: "1ef71de7661f3d00f6a2f4abc2b958758873fe8027482636cb52add54a93302b"
    sha256               arm64_sonoma:  "4e9b6084eb7533dc08146163e14d49d9d47b504464be674f14f5a4d323ed1c2d"
    sha256 cellar: :any, sonoma:        "caf05c0c3c9f0bdcd71e6f32d85cd67cf542efc050e2c526d4813ee097660fad"
    sha256               arm64_linux:   "cac915cdb429248a8adae734bab32699723c9a5d8bfe8c866818f92dc07894ef"
    sha256               x86_64_linux:  "d69d9235d81d7c9a9abafd762fac1c3e45307915d0e1ac4267b1de6fc4e3544f"
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