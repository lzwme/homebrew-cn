class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://github.com/syslog-ng/syslog-ng.git", branch: "develop"

  stable do
    url "https://ghfast.top/https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.10.2/syslog-ng-4.10.2.tar.gz"
    sha256 "841503de6c2486e66fd08f0c62ac2568fc8ed1021297f855e8acd58ad7caff76"

    # Backport Python dependency updates to avoid vulnerable packages
    patch do
      url "https://github.com/syslog-ng/syslog-ng/commit/89c1dcfb411e3c5611629fe99561f3106eb19b0f.patch?full_index=1"
      sha256 "eb42508fa0a1b716ef8967151f10fe86b427e21fc50ef2f160c14bbd35a89291"
    end
    patch do
      url "https://github.com/syslog-ng/syslog-ng/commit/dc070981e726ca1babb8e48bc368d0429eac9223.patch?full_index=1"
      sha256 "1d7bb9994f0aff742fec24a038df90d199fa2e43aae28a396dc51a892fe7a95b"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "4da3f0c277d9b5e48686e3eeaea1969bc136e145bc8d7bd81e49e70b68a9d6e7"
    sha256 arm64_sequoia: "5ef30962c64c9f2125a9401e468dd2ed23a5783f37643a105a10357ce6d361f8"
    sha256 arm64_sonoma:  "8df27c605f7ddae0fa22d6e1895fa1fc40c3631b7b5eb6a94741011e88dc9f84"
    sha256 sonoma:        "804c043bd96e0a03b46459d540a479ec23ccf4fdfc30033f6b1c195f5e54160e"
    sha256 arm64_linux:   "168d3fce7d35e417e53a2bcc66efe7f34b2430f568ced51f47dc91f9184f5bab"
    sha256 x86_64_linux:  "881a6423e58f6f14791abbac9fc6c40ecefeba38580642a62f7ab2623fe66f22"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
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