class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghproxy.com/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.2.0/syslog-ng-4.2.0.tar.gz"
  sha256 "092bd17fd47002c988aebdf81d0ed3f3cfd0e82b388d2453bcaa5e67934f4dda"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "823add8e8248ea4c2206a311797c0c887508828c2968b0b59e6b3ea1a3b49261"
    sha256 arm64_ventura:  "910f192f0e9e821da9502926c3a5af3982cad275dae6e90f20797768d064d383"
    sha256 arm64_monterey: "62a6a218f17b6195b839a080ed857fec3c6157e6ba823b7cf27facb7076327e5"
    sha256 sonoma:         "8d9464b1449917ae78b0c143a487519d9972a606d1093b79183fcdd6c323d466"
    sha256 ventura:        "06ff04bde3b5ef7cd30b484a2f1bde3d095919b9fe7e0ba6c10a25ff3db75844"
    sha256 monterey:       "5e458ac603e8caa85267e1e3bf520e4279e0f29dab83d5dedb3582361a3bb921"
    sha256 x86_64_linux:   "09513aa00e81b44f43418c5c411b775aea1dab17367042f92b84cef2e637f8f3"
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
  depends_on "python@3.12"
  depends_on "riemann-client"

  uses_from_macos "curl"

  # patch pyyaml build, remove in next release
  # relates to https://github.com/yaml/pyyaml/pull/702
  patch do
    url "https://github.com/syslog-ng/syslog-ng/commit/246dc5c8425b15a0a1ab0229e44e52f5c0aebe2c.patch?full_index=1"
    sha256 "7e75103fdeb54c185342d1dce2dc7a215c2d6812be15c5199ce480a62e2a05bf"
  end

  def install
    python3 = "python3.12"
    sng_python_ver = Language::Python.major_minor_version python3

    venv_path = libexec/"python-venv"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}/#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib/"syslog-ng/python/requirements.txt"
    venv = virtualenv_create(venv_path, python3)
    venv.pip_install requirements.read
    cp requirements, venv_path
  end

  test do
    system "#{sbin}/syslog-ng", "--version"
    system "#{sbin}/syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end