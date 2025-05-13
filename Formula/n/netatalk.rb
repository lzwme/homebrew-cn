class Netatalk < Formula
  desc "File server for Macs, compliant with Apple Filing Protocol (AFP)"
  homepage "https:netatalk.io"
  url "https:github.comNetatalknetatalkreleasesdownloadnetatalk-4-2-3netatalk-4.2.3.tar.xz"
  sha256 "10a3c3a4c11acec657df9c33c69a6269e319dba759c5e1dfa41ee5a3f1b80c43"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_sequoia: "69e46dedf08d65bed39339feb1f8869e067cbe388dcaf5656dd387f0d9daf4cc"
    sha256 arm64_sonoma:  "f6955cafb3b273d5206c68b9b0dfb84cc96710a7ee7e88c27b0dbb38a288a53b"
    sha256 arm64_ventura: "3fc7701c21ebfae0713083310756a0c44587c652394862905e66d360f39218d2"
    sha256 sonoma:        "d3fc3a551b589e4447939b2d2a45534c3e34ddb251a70b0b75b599a177b4217d"
    sha256 ventura:       "a4f38fa00e4d3e5d3a55e2131c0ea2b5962c9c46c2bd2427e38be834c4583ec0"
    sha256 arm64_linux:   "92aa0794215554271e9a7fbc52db72c474a7a12d2465da5345db5e95726c681c"
    sha256 x86_64_linux:  "a217b1d01f114b2a69080e4102066b2be1ccf566c203b5bd62f58b9a88ccea9a"
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
      "-Dwith-cups-libdir-path=#{libexec}",
      "-Dwith-cups-pap-backend=#{OS.linux?}",
      "-Dwith-docs=man,readmes,html_manual",
      "-Dwith-init-dir=#{prefix}",
      "-Dwith-init-hooks=false",
      "-Dwith-install-hooks=false",
      "-Dwith-lockfile-path=#{var}run",
      "-Dwith-pam-config-path=#{etc}pam.d",
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