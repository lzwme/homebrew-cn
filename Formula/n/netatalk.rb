class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https:netatalk.io"
  url "https:github.comNetatalknetatalkreleasesdownloadnetatalk-4-1-0netatalk-4.1.0.tar.xz"
  sha256 "96f70e0e67af6159b1465388a48d30df207f465377205ee932a1ef22617e0331"
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
    rebuild 1
    sha256 arm64_sequoia: "4ba400628f24a3994998e25f943cf94dfd323bf1600610f35a1311afa4ed153c"
    sha256 arm64_sonoma:  "03ad35c38fc00c6f4a077a7fce739f0da273e124146ed6a7eabb469359bbb8d0"
    sha256 arm64_ventura: "34340d971be79c763026573ccd78ae5bc6fbf1fd1fe41df269b27c4de15981b9"
    sha256 sonoma:        "f90e2ddca4ed7d35461e445ff78b43637fd2bdf7795e932ea22f6a4dd54e46e0"
    sha256 ventura:       "9246d1debc2b0f03b6fdda1126c52b3da5d17822d607e36f5122d77c5bec08e1"
    sha256 x86_64_linux:  "376768c86ebf412a1c352a543e4dddb395b69dbb3bb31c36a9bd06fb5e027524"
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