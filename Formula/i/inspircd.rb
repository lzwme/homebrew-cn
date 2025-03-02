class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv4.6.0.tar.gz"
  sha256 "d661648bdcb397d8bd2d4afe2746f8e991923d3d82e83d9fa215194f445977f7"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "ef37b960cd2fbab4077900418c39b0b8cb65789503e3f039746c864448fbd07e"
    sha256 arm64_sonoma:  "b9a6ac69a70a26a29e144c91cbf2c94a1a7c3388150e9cae84ff35585161ae80"
    sha256 arm64_ventura: "71497616140064f9339f8352a5b66da11ffab6b953111c4f425d0eba2d3945ba"
    sha256 sonoma:        "a5c8c9185c945cbba37610dbce033fc784d928b9011eecad4b65fa91ef959d4f"
    sha256 ventura:       "63301b70d4f91cab953d49fe1ad6b9624e20043d24430057eed37c8acecaebbb"
    sha256 x86_64_linux:  "eddcee97858d78303a325fee046244b0fc19f419c125c3a1189222b8d7e51ef7"
  end

  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "openldap"

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
    assert_match("ERROR: Cannot open config file", shell_output(bin"inspircd", 1))
  end
end