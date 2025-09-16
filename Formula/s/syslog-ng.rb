class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghfast.top/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.9.0/syslog-ng-4.9.0.tar.gz"
  sha256 "6959545cb9aaa694e4514f472c69d6e5a908abb5161861a0082c917cdf7184e2"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 6
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "8d371abf383b1fb8e8baeee034f634d8900f11cf6c5f610a4ce138470f587cc5"
    sha256 arm64_sequoia: "18e665f36041763af1503e370a46209e9f347ba509512d15a0883272a41812b4"
    sha256 arm64_sonoma:  "b5c93df95203fccd627131833b05dd978f850c02eec015bebaac66683e062ed7"
    sha256 sonoma:        "b5a9651592bacb15563bc1b74de9ba16b99934087de2f8756339e44490a599bd"
    sha256 arm64_linux:   "ef36bd1ddcb7eabfa0b548d40c2e6912f172164db4168524e06aa98a8ad852e8"
    sha256 x86_64_linux:  "9e027a914aa9d5894b0a17663679ca06788b393808478dcd85830f4a2c233d06"
  end

  depends_on "pkgconf" => :build

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
  depends_on "mongo-c-driver@1"
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
    ENV["VERSION"] = version

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    system "./configure", *std_configure_args,
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var/name}",
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
    output = shell_output("#{sbin}/syslog-ng --version")
    assert_equal "syslog-ng #{version.major} (#{version})", output.lines.first.chomp
    system sbin/"syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end