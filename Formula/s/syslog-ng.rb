class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.8.1syslog-ng-4.8.1.tar.gz"
  sha256 "e8b8b98c60a5b68b25e3462c4104c35d05b975e6778d38d8a81b8ff7c0e64c5b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 11
  head "https:github.comsyslog-ngsyslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3c8043c93c8b80daa5f431c1a25db6fe863544b767b78ff3f2c84f5ad6030fb0"
    sha256 arm64_sonoma:  "03bcbccb852331ec2bebc9632637a7066256224213b4f54e996eaf50073f1817"
    sha256 arm64_ventura: "709e591c4630be94493363dd299fd0b8249cee98ebf65a96a579d9dd4617ccb0"
    sha256 sonoma:        "c809d3f0aa7b7eb3c052003c2f1e702c108a4006fdb426473481d0dcfaf15d34"
    sha256 ventura:       "dbdb20a5c09b2215e332f6f73a9120051bcc1029c3eeae3758bf9314e83357db"
    sha256 arm64_linux:   "8ffb8f793e19c0e79c31acb82ca4e24e7bdcdcaaccb60b384956d03fc4379df4"
    sha256 x86_64_linux:  "80768c5b786ca04853df4d08c30953e492a04523c7539c9c16fd6ea1f3239df4"
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
    # https:github.comsyslog-ngsyslog-ngblobmasterrequirements.txt
    args = std_pip_args(prefix: false, build_isolation: true).reject { |s| s["--no-deps"] }
    system python3, "-m", "pip", "--python=#{venv.root}binpython",
                          "install", *args, "--requirement=#{buildpath}requirements.txt"

    system ".configure", *std_configure_args,
                          "CXXFLAGS=-std=c++17",
                          "--disable-silent-rules",
                          "--enable-all-modules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{varname}",
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