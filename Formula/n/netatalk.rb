class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https:netatalk.io"
  url "https:github.comNetatalknetatalkreleasesdownloadnetatalk-4-1-2netatalk-4.1.2.tar.xz"
  sha256 "a825f6ff7efedb09bb9ca75727ab43126797000f89775db72c8d9520bf481e9c"
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
    sha256 arm64_sequoia: "e5ca1cf2d2420016697db0193c6a5bacb41710df3161185656ab7a3d428b4c5a"
    sha256 arm64_sonoma:  "2ba4064b6e7fcf34437fa8dc2674e3a1a447c61fb46b75d31d03580dae5162ed"
    sha256 arm64_ventura: "f3bb55b4643e95a02e870f07752a58ad8c29692844b1fab7e2eff564e797c41d"
    sha256 sonoma:        "394a0ab15551ff533d298540907f64c0f4450651f8ec9e5d8c3dae47ee96014c"
    sha256 ventura:       "dd248035c5beccddd7e137c45d4fe5548d71d61b747d0b1b43c6cbc9c068e2d9"
    sha256 x86_64_linux:  "ac95460c6afb5b63cd342664fa4b50e46b8cd3e8808a85a998de165a55663589"
  end

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "cracklib"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mariadb-connector-c"
  depends_on "openldap" # macOS LDAP.Framework is not fork safe

  uses_from_macos "libxslt" => :build

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  on_linux do
    depends_on "avahi" # on macOS we use native mDNS instead
    depends_on "cups" # used by the AppleTalk print server
    depends_on "libtirpc" # on macOS we use native RPC instead
    depends_on "linux-pam"
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
      "-Dwith-lockfile-path=#{var}run",
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

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          Authenticating as a system user requires manually installing the
          PAM configuration file to a predetermined location by running:

            sudo install -d -o $USER -g admin usrlocaletc
            mkdir -p usrlocaletcpam.d
            cp $(brew --prefix)etcpam.dnetatalk usrlocaletcpam.d

          See `man pam.conf` for more information.
        EOS
      end
    end
  end

  test do
    system sbin"netatalk", "-V"
    system sbin"afpd", "-V"
    assert_empty shell_output(sbin"netatalk")
  end
end