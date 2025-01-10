class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https:netatalk.io"
  url "https:github.comNetatalknetatalkreleasesdownloadnetatalk-4-0-8netatalk-4.0.8.tar.xz"
  sha256 "d09d591521b27b91b1c2a6255a2e059af8c9fda43570f983f0a145706e5f7628"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "LGPL-2.0-only",
    "LGPL-2.1-or-later",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
  ]
  head "https:github.comNetatalknetatalk.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "5aff5ad6a6dccba9fab03fd27a12cd517ab04f73c535b7b45535cf13d8957175"
    sha256 arm64_sonoma:  "d9146fce6e190d8f5558389f6ee795331dd801f6af42cb7a57a2b246b8e9277f"
    sha256 arm64_ventura: "ea9c8c297943ae06289cecaecc46873808e4c025dcd26efb2cd14c960c4613a9"
    sha256 sonoma:        "22af562496f53cffb3aa4ed4d5f6be7dbbe29e35fe9720c5942d1e4c180e1d38"
    sha256 ventura:       "f54bb34fae8700afc7eebfe3946fcb9442d2eaabc5f55391803e2fc50605e074"
    sha256 x86_64_linux:  "eeaf7470fce660f94284f477223bf45fb9ccafa4c4f06217e317e6d24a53f018"
  end

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "cracklib"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mysql"
  depends_on "openldap" # macOS LDAP.Framework is not fork safe

  uses_from_macos "libxslt" => :build

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  on_linux do
    depends_on "avahi" # on macOS we use native mDNS instead
    depends_on "cups" # used by the AppleTalk print server
    depends_on "libtirpc" # on macOS we use native RPC instead
  end

  patch do
    url "https:github.comNetatalknetatalkcommit206fb7771862b9b98452c934dac884aaa397c8ca.patch?full_index=1"
    sha256 "fd448734556daf0344be4fa0bb09e4704c4123078ad804069d288aa0e3e104d6"
  end

  def install
    inreplace "distribinitscriptsmacos.netatalk.in", "@sbindir@", opt_sbin
    inreplace "distribinitscriptsmacos.netatalk.plist.in", "@bindir@", opt_bin
    inreplace "distribinitscriptsmacos.netatalk.plist.in", "@sbindir@", opt_sbin
    inreplace "distribinitscriptssystemd.netatalk.service.in", "@sbindir@", opt_sbin
    bdb5_rpath = rpath(target: Formula["berkeley-db@5"].opt_lib)
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
      "-Dwith-afpstats=false",
      "-Dwith-appletalk=#{OS.linux?}", # macOS doesn't have an AppleTalk stack
      "-Dwith-bdb-path=#{Formula["berkeley-db@5"].opt_prefix}",
      "-Dwith-docbook-path=#{Formula["docbook-xsl"].opt_prefix}docbook-xsl",
      "-Dwith-init-dir=#{prefix}",
      "-Dwith-init-hooks=false",
      "-Dwith-install-hooks=false",
      "-Dwith-statedir-path=#{var}",
      "-Dwith-pam-config-path=#{etc}pam.d",
      "-Dwith-rpath=false",
      "-Dwith-spotlight=false",
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    name macos: "io.netatalk.daemon", linux: "netatalk"
    require_root true
  end

  test do
    system sbin"netatalk", "-V"
    system sbin"afpd", "-V"
    assert_empty shell_output(sbin"netatalk")
  end
end