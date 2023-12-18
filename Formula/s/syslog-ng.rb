class SyslogNg < Formula
  include Language::Python::Virtualenv

  desc "Log daemon with advanced processing pipeline and a wide range of IO methods"
  homepage "https:www.syslog-ng.com"
  url "https:github.comsyslog-ngsyslog-ngreleasesdownloadsyslog-ng-4.5.0syslog-ng-4.5.0.tar.gz"
  sha256 "08828ed200436c3ca4c98e5b74885440661c1036965e219aa9261b31a24fa144"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "57fef7bbe4d00d32ed0f11c3ac47754d8634f613dbb604a0a6a50709342d60dd"
    sha256 arm64_ventura:  "ca7b97622919ed44c650400160162d0289020746abe76988f939df520374f955"
    sha256 arm64_monterey: "8edf70a324372940cdfc299674f9e5022c5f20ef331bb8465812b6fed0a0ce92"
    sha256 sonoma:         "aeb0c36d3eeb17b092a0e2ea9bf03978e58cb3465ce77326f2de9378bfc6058d"
    sha256 ventura:        "e6a4506628a8e69ed74b12b2017ca74a5d7c224013328b52a0219e3d21f96a60"
    sha256 monterey:       "522261af306fb091db704430a2f6807e7c51be75b4ad5763206de817836c933b"
    sha256 x86_64_linux:   "d8d85ad7330e5a5cf0398fd1a62c998dcb7503b1f17f671aa3b89b3971e448ad"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "riemann-client"

  uses_from_macos "curl"

  # Clang c++ compilation fixes.
  # Remove when merged and released: https:github.comsyslog-ngsyslog-ngpull4739
  # See also: https:github.comHomebrewhomebrew-corepull156185#issuecomment-1837419001
  patch do
    url "https:github.comsyslog-ngsyslog-ngcommit27db599781eaf07ed6a93d96564df4e126dd1518.patch?full_index=1"
    sha256 "1f78793bb456d7ee7656116b2238ded280cf42ebb4b37b65de20cb26ba753041"
  end

  def install
    # In file included from LibraryDeveloperCommandLineToolsSDKsMacOSX14.sdkusrincludec++v1compare:157:
    # .version:1:1: error: expected unqualified-id
    rm "VERSION"
    ENV["VERSION"] = version

    python3 = "python3.12"
    sng_python_ver = Language::Python.major_minor_version python3

    venv_path = libexec"python-venv"
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}#{name}",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--with-python-venv-dir=#{venv_path}",
                          "--disable-afsnmp",
                          "--disable-example-modules",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"

    requirements = lib"syslog-ngpythonrequirements.txt"
    venv = virtualenv_create(venv_path, python3)
    venv.pip_install requirements.read.gsub(#.*$, "")
    cp requirements, venv_path
  end

  test do
    assert_equal "syslog-ng #{version.major} (#{version})",
                 shell_output("#{sbin}syslog-ng --version").lines.first.chomp
    system "#{sbin}syslog-ng", "--cfgfile=#{pkgetc}syslog-ng.conf", "--syntax-only"
  end
end