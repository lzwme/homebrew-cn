class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.5.tar.bz2"
  sha256 "c144feb23cfc2cd47ebf335132aea0afab605adb4ff4f30955be3445034e0def"
  license "GPL-2.0-or-later"

  # The first-party download page (https://www.powerdns.com/downloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page if/when it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "58434faaef436b5a4b22e0bdeba81263a213eb81899e6bb7475682845db02fe7"
    sha256 arm64_sequoia: "88786bdb99d70b478f6bc32acdee5a781a543ba9fc56e50d24c26ca0f6c3f212"
    sha256 arm64_sonoma:  "0521a357a321cf2ccece2f3cc3c410eed10b5929e5ff553c235f778da839704a"
    sha256 sonoma:        "9102d10498b94b90af504d35a4624b8d9ea3057c1306ccf33a9585da8eb09209"
    sha256 arm64_linux:   "646da0f7523dc5e15d1285bcaf4d26d08e430fd0b2abde5f8ae5bfa66fce5c50"
    sha256 x86_64_linux:  "6ff637703429b14bbdc893bbc4c3fa9a2ab6024595cbd57d3bc34b2c181bbce3"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end