class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghfast.top/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.1/syslog-ng-4.10.1.tar.gz"
  sha256 "dea90cf1dc4b8674ff191e0032f9dabc24b291abfd7f110fd092ae5f21cde5d7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 6
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "12ee770e2ff8f3667d3ab47a108b4aba47df3a892b30a7b42069ab49db506a4e"
    sha256 arm64_sequoia: "a2142a24f087270ce574c42998a2bd731b116641811111df0220a9e4259d84f3"
    sha256 arm64_sonoma:  "307b682578c74e5dbfe46a207ad45300c2a0f54b20a43e1696f2c1c8db0276f1"
    sha256 sonoma:        "0ee6a95ea4c27c2db74d47eb422ab211c9ea5cd57cb3e7f28a66353182da5c14"
    sha256 arm64_linux:   "f8fe650dd864fcaa9c90b66b875aab72974277e0afbe7579223fc49efda5b946"
    sha256 x86_64_linux:  "12ddb048362ae3d0ff0d702603266debd4a5965e7a6d5dc001d54301a637f8db"
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
    depends_on "gettext"
  end

  def install
    ENV["VERSION"] = version

    # Workaround to allow Python 3.13+
    inreplace "requirements.txt", "PyYAML==6.0.1", "PyYAML==6.0.2"

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    # FIXME: we should use resource blocks but there is no upstream pip support besides this requirements.txt
    # https://github.com/syslog-ng/syslog-ng/blob/master/requirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python",
                          "install", *args, "--requirement=#{buildpath}/requirements.txt"

    ENV.append "CXXFLAGS", "-std=c++17"

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