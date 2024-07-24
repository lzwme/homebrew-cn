class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.8.0syslog-ng-4.8.0.tar.gz"
  sha256 "f2035546af5fcc0c03a8d03f5f0e929ce19131a428d611c982a5fea608a5d9d6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "c12c97cb63cc78dd24bd11184b3a603d315c57c9768661762b0121ff85f382f1"
    sha256 arm64_ventura:  "16164beb37e9fca01a9c10132f0b8e1e6f025ce021ae06d4b41d78f73f482b2d"
    sha256 arm64_monterey: "8de488f6bc784a77d3bfe687aa433e530755c1e55b8dbff4b4984009b0389e18"
    sha256 sonoma:         "7eeaef857d7f609ea1f1b16a99d0079d668b044a5a62fd929c142916f4c6a56a"
    sha256 ventura:        "81c331142b9f783646192a81af6290bd1768e8833e59afa4511cac8753fa6d9e"
    sha256 monterey:       "ceee07413334402d6ec99644a0031e9eab795a0dba4cb09dfd600af07bcef521"
    sha256 x86_64_linux:   "8b8992c943c83726ddaf465c4949d6461b51c9d88209520249050c1be0bd6895"
  end

  depends_on "pkg-config" => :build

  depends_on "abseil"
  depends_on "glib"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "libpaho-mqtt"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "net-snmp"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "python@3.12"
  depends_on "rabbitmq-c"
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
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp",
                          # enable this after v4.8.0 is released: https:github.comsyslog-ngsyslog-ngpull4924
                          "--disable-grpc"
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