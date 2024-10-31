class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=sharethiswithguest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMBCIFS file, print, and login server for UNIX"
  homepage "https:www.samba.org"
  url "https:download.samba.orgpubsambastablesamba-4.21.1.tar.gz"
  sha256 "bd02f55da538358c929505b21fdd8aeba53027eab14c849432a53ed0bae1c7c2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:www.samba.orgsambadownload"
    regex(href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "2ba64d8ce047f1c9b57e9bb7c6e3c61b2ca6e6db4790936471626cfd4b36f2cf"
    sha256 arm64_sonoma:  "23c64e1c6aee4caf639d32d1fa95d778d8482b7b7312d7811c3f35ef315cbfce"
    sha256 arm64_ventura: "3a6a9ac80f9cdb885c4c4803a918a5336024aad2ae726353c611f6211c922f9a"
    sha256 sonoma:        "965a168684e647c0c9ab364645a89843a2cf0b8f7b7d9067609cc2eb2b2c3c3e"
    sha256 ventura:       "468c65728c41123f53dc71835d199e620d5c7823bc7856522b6583fe8b1b105f"
    sha256 x86_64_linux:  "f2bd1912aa417209546ce88e057aba04ee144180d2a509e2d0f32bab01049664"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c@75"
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