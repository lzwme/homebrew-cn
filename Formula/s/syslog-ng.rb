class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghfast.top/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.9.0/syslog-ng-4.9.0.tar.gz"
  sha256 "6959545cb9aaa694e4514f472c69d6e5a908abb5161861a0082c917cdf7184e2"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 5
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "5c6c9bacc12dfb440037609b5c2d436aa52b9fa9395f86b4d159fb5bfb689002"
    sha256 arm64_sonoma:  "c1a4ef93509c590506db9d66935a9c15366c6699c64080273a1877499eeb203f"
    sha256 arm64_ventura: "9b36999076709463213effa8f0be340e77ec2bf0d7c57b90449bdb9d93fc0e80"
    sha256 sonoma:        "e12ac8ddecb10fa60a9a0dbc6a8e8a272dd67e533e2703702b044bec8c713eac"
    sha256 ventura:       "508cebb027914814b6fcc56c9e256341e3efb66de2ba06022fcb767485d7671a"
    sha256 arm64_linux:   "3ccc7ca262052030a47b6cc0008c696a12efcb3cc93be14aea98ab2b359cbcad"
    sha256 x86_64_linux:  "d07ae290a62e19acf1de1ff7f7feafba9b4d00f5912722f01af35e3691ef8bd6"
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