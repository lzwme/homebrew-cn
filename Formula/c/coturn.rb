class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://ghfast.top/https://github.com/coturn/coturn/archive/refs/tags/4.17.0.tar.gz"
  sha256 "61d2baf4631c7953c6b10a5fb7f4ee98a67f0326b7a53f11f15eda75be9c925a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "3518067d4126add2b8f07b5e1a26f753207318da35d46f757fcd6586600eef4c"
    sha256               arm64_sequoia: "1d29e55dfa93bb2e21f43210e98ac612d6d55b691072cb92fd389d7a4ee94e1b"
    sha256               arm64_sonoma:  "2029f4e5508c48fc3693411393dd775cda03d1fb33cea708be945fbd3b726322"
    sha256 cellar: :any, sonoma:        "76b66f029683ffe2e81896a708db11f96e3b215d864831691f18a1ad83656c35"
    sha256               arm64_linux:   "486b61a1c3838360c7acd382801e829c17b5c8292c929ead504a9ad353946780"
    sha256               x86_64_linux:  "0a4df0b5eb7ced23abf99cec95b4e72a4996eb1f714a9e95b001ef2049fafe8a"
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