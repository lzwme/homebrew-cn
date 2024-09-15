class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.8.0syslog-ng-4.8.0.tar.gz"
  sha256 "f2035546af5fcc0c03a8d03f5f0e929ce19131a428d611c982a5fea608a5d9d6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 5
  head "https:github.comsyslog-ngsyslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "037b03110179fb34f5bb3eca8bd0b867711e313a789b721c9593a839e655aba4"
    sha256 arm64_sonoma:  "4bee312ca0a974fb7a19117309da9a812e9b67281a240959a5049f8766752f8f"
    sha256 arm64_ventura: "942b063db638908b79a393367e403d028eeb920cde2312d64dd5e6ba5ea60149"
    sha256 sonoma:        "c8d40ceae9350738ae3c88bd7faa61290a078fdc76ed4c806a4062c84ae22055"
    sha256 ventura:       "0fe054c545d1541d84ffe7ee7de921045ce6213f19c04120c842d3a2f22c37c9"
    sha256 x86_64_linux:  "aad33ab5a240d262083a9a67a009d31d7c6b959557fd6e7f816aa88b18aea790"
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