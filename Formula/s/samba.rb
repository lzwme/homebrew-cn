class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=sharethiswithguest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMBCIFS file, print, and login server for UNIX"
  homepage "https:www.samba.org"
  url "https:download.samba.orgpubsambastablesamba-4.20.2.tar.gz"
  sha256 "f969ffed58ccf3e85cbbcc0e33a1726d025c2b40f42a653b1125b82b92d2e0e5"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:www.samba.orgsambadownload"
    regex(href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "dbc4652d66ee296a45b800b7561bea8d298890aeda5769497ae48c22cab9aa52"
    sha256 arm64_ventura:  "e640bd9bc121644ba2975c391ef3f4d9a72e202d22f52d88ab086010d0cbd818"
    sha256 arm64_monterey: "3d13cc668f58122170770689cfe4f9f0cb5af56656aa400b06bc86833e044748"
    sha256 sonoma:         "74f8233c0a347add0740f7b06f66bd388317d869c5e2f385e4780dc6ecb1ad5d"
    sha256 ventura:        "0d94fb1010ff4dffb7f524dfd51bdac411e45cdfad093475b86c26dfd790eda4"
    sha256 monterey:       "e32554b6a7e5e0628185ee4cfab3375c727e7d3f92eb86161c1e171442cec21b"
    sha256 x86_64_linux:   "6518e50946f700bd797cd7bd3ff2059c33b59ef4a6dbf5396da3acb78bbb635e"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c"
  depends_on "krb5"
  depends_on "libtasn1"
  depends_on "popt"
  depends_on "readline"
  depends_on "talloc"

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
           "--bundled-libraries=NONE,ldb,tdb,tevent",
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
    if OS.mac?
      # macOS has its own SMB daemon as usrsbinsmbd, so rename our smbd to samba-dot-org-smbd to avoid conflict.
      # samba-dot-org-smbd is used by qemu.rb .
      # Rename profiles as well to avoid conflicting with usrbinprofiles
      mv sbin"smbd", sbin"samba-dot-org-smbd"
      mv bin"profiles", bin"samba-dot-org-profiles"
    end
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