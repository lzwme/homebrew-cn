class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.0.1/syslog-ng-4.0.1.tar.gz"
  sha256 "c16eafe447191c079f471846182876b7919d3d789af8c1f9fe55ab14521ceb2c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_ventura:  "78a49eb06d82535a6ebc2161cb1c79b6daba8a3ad9f758b48937d64969f7df1b"
    sha256 arm64_monterey: "96d637e00617c3cc890e369434443ffea941972bf88a47dda0f2812cb77dcade"
    sha256 arm64_big_sur:  "0bdf1ba4f15b138b4649499abad8ae7e2b309762262657fc42b3f23994b50b2a"
    sha256 ventura:        "9f3139fcf42f667511dfe2d530aaa4975c60f14baf3ec981d5198cf4eef81362"
    sha256 monterey:       "8ed4a28175302a9b32325580321d2a00be2f44861910d557dca7507dd9db4cee"
    sha256 big_sur:        "d114d13dbea57ccecf46e1dee29b05a7eac5f719bbf5fed9098b962136656e9e"
    sha256 x86_64_linux:   "99dbf11d82ab67cb340771ea32a3a1db71831a1cd56fa8eaace0a977d9b5f7ea"
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