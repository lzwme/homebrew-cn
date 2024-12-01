class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.8.1syslog-ng-4.8.1.tar.gz"
  sha256 "e8b8b98c60a5b68b25e3462c4104c35d05b975e6778d38d8a81b8ff7c0e64c5b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 4
  head "https:github.comsyslog-ngsyslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "270f1cae1c0a92f1808c3c028009a270cd3cc1dfe6e5081d4037c462bec42558"
    sha256 arm64_sonoma:  "a30942a5e537837bea6e5834f31c81d119da25592c88af0beb0137cf03fb0613"
    sha256 arm64_ventura: "ce8827d6884afc8f896ddf96c30f4d9cfbb23b8c827cb58153575554221e95b3"
    sha256 sonoma:        "d2a447d07e25c4279ca21e65f889154471441c649ab1ddff5dd39b5b6a342df3"
    sha256 ventura:       "63579878afac36f32b28561ec4c2f3526e96bd53aca4e4ed2798d00b7f0f7e0b"
    sha256 x86_64_linux:  "a5ddb2e5a8df3fa6c40ca7b86f761883630a0c6c13359941abee25fd5100f76c"
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