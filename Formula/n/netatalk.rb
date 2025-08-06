class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://ghfast.top/https://github.com/Netatalk/netatalk/releases/download/netatalk-4-3-0/netatalk-4.3.0.tar.xz"
  sha256 "bc71a6a2f11cf00cb69ef13e8487ab78d1241ae535feb010220c74c89dc890fb"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "LGPL-2.0-only",
    "LGPL-2.1-or-later",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
  ]
  head "https://github.com/Netatalk/netatalk.git", branch: "main"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_sequoia: "4800ca9b8e1b9bb7278186c01cba8b2bfd3b7cff962f7a124e6a6b9a818e0d43"
    sha256 arm64_sonoma:  "c55e6b5321ce21f7bf1e82f7aab5f22008c771e7e08bf705eda10ea34e11b8c9"
    sha256 arm64_ventura: "42419b170d0d5b7b96af5756ddbd3ff5ec6f2ad16eea35a9dcd143b8f0ea8243"
    sha256 sonoma:        "11b8669ae277c25960b4418df3b25c65c0460155a0522b09b059d3cdd8c88b7d"
    sha256 ventura:       "a3463716d5c66d2a90b84957dfa73cc7fb9f83f9d4486a25a97eeb47907b77e0"
    sha256 arm64_linux:   "ca689a63c55901555e121ada20539e71282a9743a4acc3f7837c4d580e9661ec"
    sha256 x86_64_linux:  "8eaa9d719c089a01dfc2a7b01f64e4f988692e9132e4f58e624f484956873333"
  end

  depends_on "cmark-gfm" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "cracklib"
  depends_on "iniparser"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mariadb-connector-c"
  depends_on "openldap" # macOS LDAP.Framework is not fork safe

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  on_linux do
    depends_on "avahi" # on macOS we use native mDNS instead
    depends_on "cups" # used by the AppleTalk print server
    depends_on "libtirpc" # on macOS we use native RPC instead
    depends_on "linux-pam"
  end

  conflicts_with "ad", because: "both install `ad` binaries"

  def install
    inreplace "distrib/initscripts/macos.netatalk.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@bindir@", opt_bin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/systemd.netatalk.service.in", "@sbindir@", opt_sbin
    bdb5_rpath = rpath(target: Formula["berkeley-db@5"].opt_lib)
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
      "-Dwith-afpstats=false",
      "-Dwith-appletalk=#{OS.linux?}", # macOS doesn't have an AppleTalk stack
      "-Dwith-bdb-path=#{Formula["berkeley-db@5"].opt_prefix}",
      "-Dwith-cups-libdir-path=#{libexec}",
      "-Dwith-cups-pap-backend=#{OS.linux?}",
      "-Dwith-docs=man,readmes,html_manual",
      "-Dwith-homebrew=true",
      "-Dwith-init-dir=#{prefix}",
      "-Dwith-init-hooks=false",
      "-Dwith-install-hooks=false",
      "-Dwith-lockfile-path=#{var}/run",
      "-Dwith-pam-config-path=#{etc}/pam.d",
      "-Dwith-rpath=false",
      "-Dwith-spotlight=false",
      "-Dwith-statedir-path=#{var}",
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

            sudo install -d -o $USER -g admin /usr/local/etc
            mkdir -p /usr/local/etc/pam.d
            cp $(brew --prefix)/etc/pam.d/netatalk /usr/local/etc/pam.d

          See `man pam.conf` for more information.
        EOS
      end
    end
  end

  test do
    system sbin/"netatalk", "-V"
    system sbin/"afpd", "-V"
    assert_empty shell_output(sbin/"netatalk")
  end
end