class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://ghfast.top/https://github.com/Netatalk/netatalk/releases/download/netatalk-4-5-2/netatalk-4.5.2.tar.xz"
  sha256 "2cdfd5420e8e91c85c82dda66a92dcdd5974eef076feb169b279c600133f38b2"
  license all_of: [
    "GPL-2.0-or-later",

    # Licenses covering individual source files or modules. MIT is omitted because we don't install Webmin module
    "BSD-2-Clause",      # config/pap.in
    "BSD-3-Clause",      # bin/nad/nad_{cp,util}.c, etc/afpd/nfsquota.c, etc/papd/{lp,printcap}.c, ...
    "HPND",              # COPYRIGHT (Regents of The University of Michigan)
    "HPND-Pbmplus",      # COPYRIGHT (Adrian Sun)
    "Kazlib",            # etc/afpd/hash.*, include/atalk/hash.h
    "LGPL-2.0-or-later", # libatalk/unicode/charsets/mac_{centraleurope,cyrillic,greek,hebrew,turkish}.h
    "LGPL-2.1-or-later", # bin/nad/ftw.*
  ]
  head "https://github.com/Netatalk/netatalk.git", branch: "main"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "cdae37f3155f713649300d7c51cb61aeb0c7c073a5ba2421a720404cb99b7e03"
    sha256 arm64_sequoia: "2de880eea90f020930ccf95d0e9065c0b5a2d025edb02f88a8e93d4da5c010f3"
    sha256 arm64_sonoma:  "0f1c704ea24b187601630efe46a514dff91b2b61db1d03f24ec3235ec4f4bf11"
    sha256 arm64_linux:   "ac1aa292c57e55ff5c3ee4335dd960c81e7106747d3f7a4a19a19d5dc9538904"
    sha256 x86_64_linux:  "383511bfe436b704decfd9fab9a13a84bcfae8b96a6e1d3e269230bc4a6d2cbf"
  end

  depends_on "cmark-gfm" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "bstring"
  depends_on "cracklib"
  depends_on "iniparser"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mariadb-connector-c"
  depends_on "openldap" # macOS LDAP.Framework is not fork safe
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "avahi" # on macOS we use native mDNS instead
    depends_on "cups" # used by the AppleTalk print server
    depends_on "libtirpc" # on macOS we use native RPC instead
    depends_on "linux-pam"
  end

  def install
    inreplace "distrib/initscripts/macos.netatalk.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@bindir@", opt_bin
    inreplace "distrib/initscripts/macos.netatalk.plist.in", "@sbindir@", opt_sbin
    inreplace "distrib/initscripts/systemd.netatalk.service.in", "@sbindir@", opt_sbin
    bdb5_rpath = rpath(target: formula_opt_lib("berkeley-db@5"))
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
      "-Dwith-appletalk=#{OS.linux?}", # macOS doesn't have an AppleTalk stack
      "-Dwith-bdb-path=#{formula_opt_prefix("berkeley-db@5")}",
      "-Dwith-cups-libdir-path=#{libexec}",
      "-Dwith-cups-pap-backend=#{OS.linux?}",
      "-Dwith-docs=man,readmes,html_manual",
      "-Dwith-homebrew=true",
      "-Dwith-init-dir=#{prefix}",
      "-Dwith-init-hooks=false",
      "-Dwith-install-hooks=false",
      "-Dwith-lockfile-path=#{var}/run",
      "-Dwith-pam-config-path=#{etc}/pam.d",
      "-Dwith-pkgconfdir-path=#{pkgetc}",
      "-Dwith-spotlight=true",
      "-Dwith-statedir-path=#{var}",
      "-Dwith-testsuite=true",
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
    pidfile = var/"run/netatalk#{".pid" if OS.mac?}"
    port = free_port
    (testpath/"afp.conf").write <<~CONF
      [Global]
      afp port = #{port}
      log file = #{testpath}/afpd.log
      log level = default:info
      signature = 1234567890ABCDEF
    CONF
    fork do
      system sbin/"netatalk", "-d", "-F", testpath/"afp.conf"
    end
    system sbin/"afpd", "-V"
    system sbin/"netatalk", "-V"
    sleep 5
    assert_match "AFP reply", shell_output("#{bin}/asip-status localhost #{port}")
    pid = pidfile.read.chomp.to_i
  ensure
    Process.kill("TERM", pid)
  end
end