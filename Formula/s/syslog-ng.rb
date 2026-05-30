class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghfast.top/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.11.0/syslog-ng-4.11.0.tar.gz"
  sha256 "37ea0d4588533316de122df4e1b249867b0a0575f646c7478d0cc4d747462943"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 6
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "7b7dcc29e6d79c596373ce2c382ed693dcc074f92dfaf2271349320981231c25"
    sha256 arm64_sequoia: "3e6a3cfcc964bbd50d0ec8d98288fe797749ffc6d3b3f8eeba37c717dd7c2ffd"
    sha256 arm64_sonoma:  "acdc5bc9abbe6533419f519f4ce24c03ed5a699796fb123f5745ec192a2eae94"
    sha256 sonoma:        "a534bbf455ff4fb4623ef4a25778a3e2b807a85d5f8762c3ab7cb73bc48494a8"
    sha256 arm64_linux:   "ba545121c141dd0d6f860e48c1ba6ae7ce4860aeb73ee916a75694a41da0a7a3"
    sha256 x86_64_linux:  "f63371f25a18f6a3194672684275e9716377eb4f9093351fc98bf81e680557ec"
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
  depends_on "mongo-c-driver"
  depends_on "net-snmp"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "rabbitmq-c"
  depends_on "riemann-client"

  uses_from_macos "curl"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["VERSION"] = version

    # Need to regenerate configure on macOS to avoid undefined symbols, e.g. "_evt_tag_errno"
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    system "./configure", "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var/name}",
                          "--with-ivykis=system",
                          "--with-python=#{Language::Python.major_minor_version python3}",
                          "--with-python-venv-dir=#{venv.root}",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules",
                          "--disable-smtp",
                          *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/syslog-ng --version")
    assert_equal "syslog-ng #{version.major} (#{version})", output.lines.first.chomp
    system sbin/"syslog-ng", "--cfgfile=#{pkgetc}/syslog-ng.conf", "--syntax-only"
  end
end