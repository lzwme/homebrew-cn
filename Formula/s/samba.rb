class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=sharethiswithguest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMBCIFS file, print, and login server for UNIX"
  homepage "https:www.samba.org"
  url "https:download.samba.orgpubsambastablesamba-4.22.2.tar.gz"
  sha256 "d9ac8e224a200159e62c651cf42307dc162212ec25d04eb6800b9a7ccfbcc3c1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:www.samba.orgsambadownload"
    regex(href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "280b83a40be9d9fade921dcfaf2894c76b45fcc3f7b76c6a599dae276b7d335a"
    sha256 arm64_sonoma:  "03cb00192b94f6ba98baa46074202c83113b5e86385874fd1b7435afbf247adb"
    sha256 arm64_ventura: "8a771e20d92e97c21b905a55d5a37a1bdad2c77c254921ae2aa6842856c0fbcd"
    sha256 sonoma:        "6f11408b6f1f73b14d425d2a5a5db8bb65feb587783b3938fa42ed85fd61da38"
    sha256 ventura:       "1ca95dc2b6a99bb734494d46ce84a93a3eb81573cd3ad93ec54a811aa55911b4"
    sha256 arm64_linux:   "ce733bfadcdf5dce67a6c3a87d41823e0ad89a8fd13ddfee94f025d89b793ab2"
    sha256 x86_64_linux:  "c497d0524c1ba85e3de7a0d69411460b43b91e5aeef088fca6967d47e02b195c"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c@77"
  depends_on "krb5"
  depends_on "libtasn1"
  depends_on "libxcrypt"
  depends_on "lmdb"
  depends_on "popt"
  depends_on "readline"
  depends_on "talloc"
  depends_on "tdb"
  depends_on "tevent"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build # configure requires python3 binary
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  on_linux do
    depends_on "libtirpc"
  end

  conflicts_with "jena", because: "both install `tdbbackup` binaries"
  conflicts_with "puzzles", because: "both install `net` binaries"

  resource "Parse::Yapp" do
    url "https:cpan.metacpan.orgauthorsidWWBWBRASWELLParse-Yapp-1.21.tar.gz"
    sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
  end

  # upstream bug report, https:bugzilla.samba.orgshow_bug.cgi?id=10791
  # https:bugzilla.samba.orgshow_bug.cgi?id=10626
  # https:bugzilla.samba.orgshow_bug.cgi?id=9665
  # upstream pr ref, https:gitlab.comsamba-teamsamba-merge_requests3902
  patch do
    url "https:gitlab.comsamba-teamsamba-commita2736fe78a4e75e71b9bc53dc24c36d71b911d2a.diff"
    sha256 "7d1bf9eb26211e2ab9e3e67ae32308a3704ff9904ab2369e5d863e079ea8a03f"
  end

  def install
    # Skip building test that fails on ARM with error: initializer element is not a compile-time constant
    inreplace "libldbwscript", \('test_ldb_comparison_fold',$, "\\0 enabled=False," if Hardware::CPU.arm?

    # avoid `perl module "Parse::Yapp::Driver" not found` error on macOS 10.xx (not required on 11)
    if !OS.mac? || MacOS.version < :big_sur
      ENV.prepend_create_path "PERL5LIB", buildpath"libperl5"
      ENV.prepend_path "PATH", buildpath"bin"
      resource("Parse::Yapp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make"
        system "make", "install"
      end
    end
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}private" if OS.linux?
    system ".configure",
           "--bundled-libraries=NONE",
           "--private-libraries=!ldb",
           "--disable-cephfs",
           "--disable-cups",
           "--disable-iprint",
           "--disable-glusterfs",
           "--disable-python",
           "--without-acl-support",
           "--without-ad-dc",
           "--without-ads",
           "--without-ldap",
           "--without-libarchive",
           "--without-json",
           "--without-pam",
           "--without-regedit",
           "--without-syslog",
           "--without-utmp",
           "--without-winbind",
           "--with-shared-modules=!vfs_snapper",
           "--with-system-mitkrb5",
           "--prefix=#{prefix}",
           "--sysconfdir=#{etc}",
           "--localstatedir=#{var}"
    system "make"
    system "make", "install"
    return unless OS.mac?

    # macOS has its own SMB daemon as usrsbinsmbd, so rename our smbd to samba-dot-org-smbd to avoid conflict.
    # samba-dot-org-smbd is used by qemu.rb .
    # Rename profiles as well to avoid conflicting with usrbinprofiles
    mv sbin"smbd", sbin"samba-dot-org-smbd"
    mv bin"profiles", bin"samba-dot-org-profiles"
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid conflicting with macOS system binaries, some files were installed with non-standard name:
        - smbd:     #{HOMEBREW_PREFIX}sbinsamba-dot-org-smbd
        - profiles: #{HOMEBREW_PREFIX}binsamba-dot-org-profiles
      EOS
    end
  end

  test do
    smbd = if OS.mac?
      "#{sbin}samba-dot-org-smbd"
    else
      "#{sbin}smbd"
    end

    system smbd, "--build-options", "--configfile=devnull"
    system smbd, "--version"

    mkdir_p "sambastate"
    mkdir_p "sambadata"
    (testpath"sambadatahello").write "hello"

    # mimic smb.conf generated by qemu
    # https:github.comqemuqemublobv6.0.0netslirp.c#L862
    (testpath"smb.conf").write <<~EOS
      [global]
      private dir=#{testpath}sambastate
      interfaces=127.0.0.1
      bind interfaces only=yes
      pid directory=#{testpath}sambastate
      lock directory=#{testpath}sambastate
      state directory=#{testpath}sambastate
      cache directory=#{testpath}sambastate
      ncalrpc dir=#{testpath}sambastatencalrpc
      log file=#{testpath}sambastatelog.smbd
      smb passwd file=#{testpath}sambastatesmbpasswd
      security = user
      map to guest = Bad User
      load printers = no
      printing = bsd
      disable spoolss = yes
      usershare max shares = 0
      [test]
      path=#{testpath}sambadata
      read only=no
      guest ok=yes
      force user=#{ENV["USER"]}
    EOS

    port = free_port
    spawn smbd, "--debug-stdout", "-F", "--configfile=smb.conf", "--port=#{port}", "--debuglevel=4", in: "devnull"

    sleep 5
    mkdir_p "got"
    system bin"smbclient", "-p", port.to_s, "-N", "127.0.0.1test", "-c", "get hello #{testpath}gothello"
    assert_equal "hello", (testpath"gothello").read
  end
end