class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv4.1.0.tar.gz"
  sha256 "9efc07ae0f7e128f93b673d1312c62bd7539c65d80ec3c0c6b702136fd56d340"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "636f3f03fe9a9c1fc5550172155976be80b2f4f90678dfe93586d11d3b151459"
    sha256 arm64_ventura:  "afc488cd72bd32f8fe58e66fef1bcef27e450671ab4e784e6a88151f869a66cc"
    sha256 arm64_monterey: "d5540ba8969ac4ed5ee390cf19f02274adb1b03ef92459ce2408985d6d13b6b7"
    sha256 sonoma:         "0051d50e34b2a28928079454908b62f0f543ddeeda4cc15acbe733a660f3c390"
    sha256 ventura:        "91987da39fcc11fe13f8d2ca87e18098fe69df2e12655d798d53493ba55b97c6"
    sha256 monterey:       "208e6fbeedfdf36ad1d2c7cfbaeb71cb34d301edf974ae24869811436e803509"
    sha256 x86_64_linux:   "73d5287b273a74b469d4cbba5f98cc6edcab8ed248e016c0ef76d1ca543f9105"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  on_macos do
    depends_on "openssl@3"
    depends_on "zlib"
    depends_on "zstd"
  end

  skip_clean "data"
  skip_clean "logs"

  def install
    ENV.cxx11
    system ".configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix ssl_gnutls sslrehashsignal"
    system ".configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}inspircd", 1))
  end
end