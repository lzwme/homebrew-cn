class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  url "https://ghfast.top/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.1/syslog-ng-4.10.1.tar.gz"
  sha256 "dea90cf1dc4b8674ff191e0032f9dabc24b291abfd7f110fd092ae5f21cde5d7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "132379ca728dd937ecb23a70437f9b7307058716536e7173aebc646c8cc1a227"
    sha256 arm64_sequoia: "542265545bb76037e354d45f86c72bb10bafee1171a769adbe5bcffc4afc6495"
    sha256 arm64_sonoma:  "97e400a24a3d4506874ade947121b3014c272e6005a71b69eecb52b5702176f1"
    sha256 sonoma:        "2500f1e33e202c563f522730bdb517c01e6850d57052f80d02b38348ed2124e6"
    sha256 arm64_linux:   "0a3b8e86e2ccb9c16465e8ae67bde8b9481fd5df00e6809c6dc9a23b0279efa4"
    sha256 x86_64_linux:  "678bf6529eb2ad7ce90552581e0f94b9aa42a33bd17fe62b24abada0329f4bcf"
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