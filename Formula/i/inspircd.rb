class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv4.0.0.tar.gz"
  sha256 "528199a6c857973611d496e5a4b4d125770525c9f52cbc5f7387ecdfdfcf885c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "8500f137f88d0c21b1eb7f1c7dee9a71a16c48927311bddd87a78d6f93f6df15"
    sha256 arm64_ventura:  "d06359e934b94b5424a0bc4bb722faeb3c9a789f96d8e87897cb02eaa3c4c9c8"
    sha256 arm64_monterey: "94466e60a078280a6994a5ad85c7679330c355a5c336e127f24273e585911fbd"
    sha256 sonoma:         "12e1becf9cfa3d070b5e5ceb2e7842f7105da1e4592567fb76e6f1f3e5939b35"
    sha256 ventura:        "070621ac12cc795128c09fcae93293edb40863913d2b69e122795c54c9dda11c"
    sha256 monterey:       "3f482ee2e69e7e6ad55542748992fe8c501ea1b22ac35dbd4f8c8011efa1dbe4"
    sha256 x86_64_linux:   "7ce193973d1c834d5e4e1d0dbca842d58a7d0f2c80be7d0069c7fa22d1341627"
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