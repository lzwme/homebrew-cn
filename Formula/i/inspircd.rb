class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https:www.inspircd.org"
  url "https:github.cominspircdinspircdarchiverefstagsv3.17.1.tar.gz"
  sha256 "921fa8726676f74a9ea8670b41601c975955ad9c131e9b6eb129fa6034433cdb"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "0326259bd49a60c0dc56a3a17c814e8cf7138d702ba55b445af8deae910f0ed8"
    sha256 arm64_ventura:  "0cde9596aade07ded4059178f3916acefa6d930acc52c8f60d61a66699f93535"
    sha256 arm64_monterey: "3913f5a95f33356e79025f761f5245f4db1f825373f1f5cd0d4eb770d9fbf153"
    sha256 sonoma:         "acc41966991fd83277d38a5a30f609e36356e3b683d787a542038336e914c87e"
    sha256 ventura:        "b7d90882a5140ef5d66d06d8854fde8437fec81590e3f41967fca5bb8534477b"
    sha256 monterey:       "d7a46852ce14b4ddecfdafe6663b26cf07ac535755dffe8e7157ee7305f7c103"
    sha256 x86_64_linux:   "5c9f16a3afd6eba0bf328400d2d0148f0bbed4b0ab2b75eec7b178f1ff9a7fb6"
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
                          "argon2 ldap mysql pgsql regex_posix regex_stdlib ssl_gnutls sslrehashsignal"
    system ".configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}inspircd", 2))
  end
end