class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.1.0/syslog-ng-4.1.0.tar.gz"
  sha256 "6e8f73aa0195b3a668d0911d050284abc6c11dbb04a1c526156b57a22409e24f"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "a98bc7e7599e186e37e37763780a4e2d9ac60a65abc17d97c962bdf9190cece1"
    sha256 arm64_monterey: "7e8fedd0988c648ade04af6145af7d4c7bade33e1c9855b2ea635675372249b6"
    sha256 arm64_big_sur:  "325192b75694e14b35f7e6ecde47b1dfe18663d6d6aa2351cc0141d74de4a468"
    sha256 ventura:        "acfc5ef3758c9b675e01004a072bafffc0fd2a4ac9af70d88a51e6d5fcf8ef02"
    sha256 monterey:       "a66a56c192e5c180d11fe1ab483ab1eb37e3643f895b9d4ff41168714c83d324"
    sha256 big_sur:        "eba311d8ec7c95aa18299e9582e5f05975d4536314bc7d1de07a6c85b392ce32"
    sha256 x86_64_linux:   "dddd26b1bdd3534a4f1a3125efb32a569fd1aec296ac6454dc662e28f00a3fdb"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    sng_python_ver = Formula["python@3.11"].version.major_minor

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--disable-afsnmp",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"
  end

  test do
    system "#{sbin}/syslog-ng", "--version"
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end