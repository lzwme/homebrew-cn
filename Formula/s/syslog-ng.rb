class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.8.0syslog-ng-4.8.0.tar.gz"
  sha256 "f2035546af5fcc0c03a8d03f5f0e929ce19131a428d611c982a5fea608a5d9d6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 6
  head "https:github.comsyslog-ngsyslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "dd8a1f448590489bbcfb1878a15c3cedb11e47a5cc46f8e9c9bb917e113b5625"
    sha256 arm64_sonoma:  "4bef57e8fcfffe906cf1cd5a04a70965f6cd96c802999f045d3179020a22dd03"
    sha256 arm64_ventura: "78054cf98f49ec25fa17a8063aa32d4cdb929eda6de599816c5d38093795978d"
    sha256 sonoma:        "3aa6c90a3eff4900a7b9b3f7df03005a41b725860f1ef7c534bf003dcd5ab786"
    sha256 ventura:       "5e3ee2ac2c92f0d430e65a407d5538f5e87c19cffba2568448d80aff12928f4f"
    sha256 x86_64_linux:  "49ac43b3827722beffe8632380acf20b3c553f1acce99d9a8f0059ab50ceb21c"
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

  on_macos do
    depends_on "gettext"
  end

  def install
    # In file included from LibraryDeveloperCommandLineToolsSDKsMacOSX14.sdkusrincludec++v1compare:157:
    # .version:1:1: error: expected unqualified-id
    rm "VERSION"
    ENV["VERSION"] = version

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https:github.comsyslog-ngsyslog-ngblobmasterrequirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}binpython",
                          "install", *args, "--requirement=#{buildpath}requirements.txt"

    system ".configure", *std_configure_args,
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{Language::Python.major_minor_version python3}",
                          "--with-python-venv-dir=#{venv.root}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp"
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}syslog-ng --version")
    assert_equal "syslog-ng #{version.major} (#{version})", output.lines.first.chomp
    system sbin"syslog-ng", "--cfgfile=#{pkgetc}syslog-ng.conf", "--syntax-only"
  end
end