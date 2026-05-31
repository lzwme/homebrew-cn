class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https://netatalk.io"
  url "https://ghfast.top/https://github.com/Netatalk/netatalk/releases/download/netatalk-4-5-0/netatalk-4.5.0.tar.xz"
  sha256 "62d77f5a491e69086c1706ff7d9e016912e0e48b43d0c3a7ae60c384b6d625b3"
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
    sha256 arm64_tahoe:   "2a0d171674ac7a8dfba99b5f62716d2eecf27638bac933d262192b1afadcc333"
    sha256 arm64_sequoia: "bb70f55a6a018ec02d82a92b92745b5c8fd76c1001b7999288cfdf2950d204df"
    sha256 arm64_sonoma:  "b7152fcc4d907dc33c906fcf957da3e268fdc63ade405f4ef39209828250b85a"
    sha256 sonoma:        "455ec0fc6132ff9c346a8d5f77b774856426df4ab88a4ec7f45a4ac53ffb8abb"
    sha256 arm64_linux:   "5b170636ff4d3e19274004525dae4fce8fbf4d13ae6401172dd487850a3a4ab7"
    sha256 x86_64_linux:  "14bdaaaf50e44249e04fb30847c21d41dd9af6d2de4ba941e7dcf9dc59083e8c"
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
    bdb5_rpath = rpath(target: Formula["berkeley-db@5"].opt_lib)
    ENV.append "LDFLAGS", "-Wl,-rpath,#{bdb5_rpath}" if OS.linux?
    args = [
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
      "-Dwith-pkgconfdir-path=#{pkgetc}",
      "-Dwith-spotlight=false",
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
    (testpath/"afp.conf").write <<~EOS
      [Global]
      afp port = #{port}
      log file = #{testpath}/afpd.log
      log level = default:info
      signature = 1234567890ABCDEF
    EOS
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