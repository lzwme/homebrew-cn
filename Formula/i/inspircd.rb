class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv4.0.1.tar.gz"
  sha256 "3e00d545593f2f2585792585b58501bfc953dc16ae1f35dc55333ccb57d6ef5d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "d5abadab741ca0717579b214d91c5cd8dd965d1bcb755f632844fe2d408c67c1"
    sha256 arm64_ventura:  "82abfdd3a78022e463db28423b351f3234ac192fee85b47b4c33e8a8992afe4d"
    sha256 arm64_monterey: "7a3cbdf29a81080411b58cab08105df4ad5378d8ce46a09383ae2e84258c63eb"
    sha256 sonoma:         "634439a40b40cb558429f5fc4e68afa1eac505cd5bd8bca48b19b9cf45cf216f"
    sha256 ventura:        "426b652fd1859062899388ecb5b10328d3cd97e466497efb09cd8cc8117f4fd1"
    sha256 monterey:       "1d6429341d727e9ed7b1eea59b19bbae0d085f9d9564851cefaa1e3a31ff2c8b"
    sha256 x86_64_linux:   "40867db14252aa063c009eb300836b34059f9b350afd2cf0d60396c7361edd22"
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