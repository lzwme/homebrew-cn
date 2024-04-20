class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.7.1syslog-ng-4.7.1.tar.gz"
  sha256 "5477189a2d12325aa4faebfcf59f5bdd9084234732f0c3ec16dd253847dacf1c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "32bd87ad18d6c957acf6d18fdfe9559007fe3934cee2f2c43397317396441007"
    sha256 arm64_ventura:  "9a4afb80473105db1f8c53ce2030eab4be2dd80f8352c211fe617d75fa82372f"
    sha256 arm64_monterey: "dfd39f4c49729c14e1e02021cd638f3d58a8e15dd601dd26a5141ab9b2a5690e"
    sha256 sonoma:         "086e84e5052a5c841fc0a878cdbf89a012a0186d77133c2f0e829b1a15c61069"
    sha256 ventura:        "a83ce64252e31f4b7269e55ad02c8255d4c928e8d863959f25656763667c873e"
    sha256 monterey:       "8e078e247b38ebb3aad67afc34d4b9139484f97d211f8c44fbeee42dcb3ee074"
    sha256 x86_64_linux:   "24dadc10ff927f1c28d1bc030fcc71a7a6448a86e849e5ccb407f882894e5a6d"
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
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "riemann-client"

  uses_from_macos "curl"

  def install
    # In file included from LibraryDeveloperCommandLineToolsSDKsMacOSX14.sdkusrincludec++v1compare:157:
    # .version:1:1: error: expected unqualified-id
    rm "VERSION"
    ENV["VERSION"] = version

    python3 = "python3.12"
    sng_python_ver = Language::Python.major_minor_version python3

    venv_path = libexec"python-venv"
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib"syslog-ngpythonrequirements.txt"
    venv = virtualenv_create(venv_path, python3)
    venv.pip_install requirements.read.gsub(#.*$, "")
    cp requirements, venv_path
  end

  test do
    assert_equal "syslog-ng #{version.major} (#{version})",
                 shell_output("#{sbin}syslog-ng --version").lines.first.chomp
    system "#{sbin}syslog-ng", "--cfgfile=#{pkgetc}syslog-ng.conf", "--syntax-only"
  end
end