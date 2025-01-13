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
    sha256 arm64_sequoia: "f23ab1e5af4633c2227a6183a38f95bf09f28604da467ee93b3e6dcf56c92730"
    sha256 arm64_sonoma:  "1042daac030536e7765f1d3485369c87a61ce1ff2571af43855f309be7a2f184"
    sha256 arm64_ventura: "4b42d75193c290ababad3050241975aa2c107872ee837ca63c25a0e5b19d1a58"
    sha256 sonoma:        "f1e296c160c78b7e903992549b129bcf52b7b10268246dc38731532675449bcb"
    sha256 ventura:       "b036cda8da411dfa81793d00ef3e240ba7ece397323f01533a7882e17bee0dd2"
    sha256 x86_64_linux:  "3bc881ceb7a164ab5b0dbfccce91a7cb5ee35236ea53c0b6bace7201abf03d69"
  end

  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "berkeley-db@5" # macOS bdb library lacks DBC type etc.
  depends_on "cracklib"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "mariadb"
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