class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv4.4.0.tar.gz"
  sha256 "9f24615b1663ca6ed611f39c3f74da291656fc88df18991ab67f1becbab40aaa"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "28f069a1b674d8e03a8154683aefc77d896e4258a7a21d186ef5ace5cab7124d"
    sha256 arm64_sonoma:  "f9dd92b838062f2277d763eccb241bab501308ef23dfa0c1adb31b4745196990"
    sha256 arm64_ventura: "2d21c7a26b916078525e054672348147be3992c7c64e70a3a3af03d8bac660f6"
    sha256 sonoma:        "fc8d3695a948848029f5c877b694ad21c2c8ddb42dc8c75a5ab24c4894305db8"
    sha256 ventura:       "411dc2f7092da05e7cf3dfe7cd1460c790c82dcc1bc184a37a1714b412e01b79"
    sha256 x86_64_linux:  "bd90281f9e1711c5cad355d8fdad5f35f660b346246b42809545ad25ddf46bda"
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
    assert_match("ERROR: Cannot open config file", shell_output(bin"inspircd", 1))
  end
end