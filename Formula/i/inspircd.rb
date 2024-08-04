class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv4.2.0.tar.gz"
  sha256 "4b07359c5528489cd312a6e1bd27a6e5161f839c62699f4d3113cb3cb50250bb"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "eccceecba2e9f7c820b5427935f48bc3e90741cac777a544a35dafb4e7889aa7"
    sha256 arm64_ventura:  "7986a7296e3a8e42cf59f49e5183f6767ea74f01af94a76ae58f6fba8f0b2bda"
    sha256 arm64_monterey: "aa1daf39b80e4ba83f4f723c315fbf5ec0062b31dd47bb028545720fd03a021c"
    sha256 sonoma:         "4c931e3e4d037d8366955298e0241c8f93c2792a19366105b474789e939dd9f7"
    sha256 ventura:        "196ca10b1db9e8b60bb1f8769b70bb9f243d35fe1791d474f2effdb9f671f3bb"
    sha256 monterey:       "d7f0c332311b9ecefe8993c84aeb0efbbf3a58c99cd760c00d8d6e99205c901d"
    sha256 x86_64_linux:   "ee49d7a150528460f685d4d7d812b28ef7f7840134b42795c22adf6317bce6cc"
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