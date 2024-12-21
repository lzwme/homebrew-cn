class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=sharethiswithguest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMBCIFS file, print, and login server for UNIX"
  homepage "https:www.samba.org"
  url "https:download.samba.orgpubsambastablesamba-4.21.2.tar.gz"
  sha256 "bde66be3d2025cb949de38518ad2652f3795f824c7fa89d4e443ede1ae828ea6"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https:www.samba.orgsambadownload"
    regex(href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "7619dec787d24ae50195ccc8232da940eb9b3ee8c13743e380f01f9934f76266"
    sha256 arm64_sonoma:  "a02b6c78c34f97eadb09445bd1029b722eb32965991e6f79c2c17e3fc725052d"
    sha256 arm64_ventura: "6255f04c3845e3399a20b32f6735bde06359283fcf77c6ee8567b07987fda19d"
    sha256 sonoma:        "2690ee2dfe0c0b1dc410059f4df97d088027e53f65d446fa6b352cb5de86a794"
    sha256 ventura:       "1a34ca730dc121b9ef1a876375cfd427523584bd1079a44cd7a388d7475795f5"
    sha256 x86_64_linux:  "af8bd2b780d28fe08107d4a081cecc97762ed95a7af2915a766dfd11f1993c72"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c@76"
  depends_on "krb5"
  depends_on "libtasn1"
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