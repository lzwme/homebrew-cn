class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://ghproxy.com/https://github.com/inspircd/inspircd/archive/refs/tags/v3.16.1.tar.gz"
  sha256 "cee0eca7b0c91ac0665199fdfb8ed4edb436a08b8b850b35e19da607c102aec0"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e88ff20d736bfdf00c8d81c47e65769a7a212052e154cd4258a3dd28bef9f277"
    sha256 arm64_monterey: "12fd165d1968121c5b6452fedaa1756acc2762326cbfc54ff0c2e3ea6891c516"
    sha256 arm64_big_sur:  "d18436c63e8eac6f6b792c305ae7f4a9d72bc2853f5bfbb1c7ab810350713ada"
    sha256 ventura:        "ee46519602b493a6b3a80635ce360e441e2ed227aa42d21a01e6c0c412b6c224"
    sha256 monterey:       "4764f21497bd63c58534988954ef0b6dcadd053a3edc05eaf6cccdaef04cb6ce"
    sha256 big_sur:        "7f8b5a49e9492e68f822fcda809fb010f05a3d4c206d4709ceb7b760ec224ad8"
    sha256 x86_64_linux:   "bd8187d3d0277df6da8e2941a843778c936988810554928f3ad8fb87c70a20fd"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    ENV.cxx11
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix regex_stdlib ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end