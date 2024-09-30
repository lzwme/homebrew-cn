class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.8.0syslog-ng-4.8.0.tar.gz"
  sha256 "f2035546af5fcc0c03a8d03f5f0e929ce19131a428d611c982a5fea608a5d9d6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 7
  head "https:github.comsyslog-ngsyslog-ng.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "fd5db4a4344228d1df41b5e7649a495a1f93feb5f03e0c76742972485beb6cf6"
    sha256 arm64_sonoma:  "a4faed874e37b300c1b33108c78d9799fd78622c40247e7ce25c60099a0dea42"
    sha256 arm64_ventura: "4a85d8346451430e296dcd153cb87d718fcbb5f43dec75d4be51e3fec98f811f"
    sha256 sonoma:        "19e132d258218453902d91cd820e16b0297c2aa41c1c8e9886ed20a77726f552"
    sha256 ventura:       "638da8292395dda27baf0a3c5a5e7d0b662621bdec5615bc44da53507a57903d"
    sha256 x86_64_linux:  "91056421577da418446be06c851082140af2de4b718769a8b3bec2d13848ab54"
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