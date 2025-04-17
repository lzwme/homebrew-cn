class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https:www.freetds.org"
  url "https:www.freetds.orgfilesstablefreetds-1.4.27.tar.bz2"
  sha256 "8c071ec625b8d3552d239e24bed8dd55f9098e0fc99397e1c926a3c27a4a32cd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www.freetds.orgfilesstable"
    regex(href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "14945840fd9d342d2e4ed96d5326fd04bd86dada685ff62d8d84974789a45217"
    sha256 arm64_sonoma:  "8aaf552e6a69ba5a112ab4efc17158130cdb1fd8351fe2172e034876a669a73b"
    sha256 arm64_ventura: "87e6d83e8ebc32e456cd896ad8aeb0f823684b3d0eef3e097511c4a2469773a4"
    sha256 sonoma:        "e2528ca9d76bb5ff7bf8afd35e3af012438dfb3e748709ffc73352625c622ec2"
    sha256 ventura:       "37c0d8e98d345b290a103a7aa8f236f14e8363611990683f1646deb9e1e5f56a"
    sha256 arm64_linux:   "163af3828402f88622e587ab6829f426940e6acfffa524e80cf8c1b4cd825fbd"
    sha256 x86_64_linux:  "fb7a23eae60c08be6b12f4064f3cdaa183581137e8bf1d9137dbd699e9cb755c"
  end

  head do
    url "https:github.comFreeTDSfreetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "krb5"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    configure = build.head? ? ".autogen.sh" : ".configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin"tsql", "-C"
  end
end