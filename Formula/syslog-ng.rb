class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.1.1/syslog-ng-4.1.1.tar.gz"
  sha256 "d7df3cfa32d1a750818d94b8ea582dea54c37226e7b55a88c3d2f3a543d8f20e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_ventura:  "da1f97b9a2f99cf642a9a0eac40d38c3c9d12caf97caa0ea954ce7067e73c2f8"
    sha256 arm64_monterey: "8c24fc791e0893ddac030fd1fdfe0f0ed02fd3e823daba394d1e32a5246c079c"
    sha256 arm64_big_sur:  "bfc09e51c35e93878d1168123a6fd60caf13a8b31d270c234d4a3fa4d1d8c10d"
    sha256 ventura:        "4ca764760ff73f2a0bc166d42a1c23b4a31bd4d71048e7ecb3a1545f0344a0fc"
    sha256 monterey:       "d3fbbdbc659d6fd18613dd1ca508a4179b02fb950217e8688e4b97cc9ea167e0"
    sha256 big_sur:        "eed75c895e0a1c499e42243cb981c00394de2c92f5ace3a1e6fee4cfd242337a"
    sha256 x86_64_linux:   "14d29820362bfcffd5a0a3d3ffd5e6fd04cdf2deade891861104536a9691492c"
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
  depends_on "openssl@3"
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