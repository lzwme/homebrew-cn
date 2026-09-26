class Samba < Formula
  # Samba can be used to share directories with the guest in QEMU user-mode
  # (SLIRP) networking with the `-net nic -net user,smb=/share/this/with/guest`
  # option. The shared folder appears in the guest as "\\10.0.2.4\qemu".
  desc "SMB/CIFS file, print, and login server for UNIX"
  homepage "https://www.samba.org/"
  url "https://download.samba.org/pub/samba/stable/samba-4.25.0.tar.gz"
  sha256 "2e2cb7296833b35b8f7a7fb76045e0c57adc0c2cd03264b37df5d58e40f28437"
  license "GPL-3.0-or-later"
  compatibility_version 2

  livecheck do
    url "https://www.samba.org/samba/download/"
    regex(/href=.*?samba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "fd521b4639ed9029675e07c2f6e986902e62eb727d6dafcfdcbc61e7c2b0c003"
    sha256 arm64_tahoe:       "2ade08fb55d5723790bc3ace95d096f032d26b2905c8e9d8be8f30df9b536f3a"
    sha256 arm64_sequoia:     "0921e42b55ccaa7e694278acaba74405f2a875e2a52cdc14430f2cca181de3e6"
    sha256 arm64_linux:       "f7e8cd9839cfc320b56eedf128e1e9926cf1a1df4dd2685139b25174289ca720"
    sha256 x86_64_linux:      "031466c8ad75a6f4e12a250aae7f041a1f8a97018fc3a1fb9d4a9cb272e66fc8"
  end

  depends_on "bison" => :build
  depends_on "cmocka" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  # icu4c can get linked if detected by pkg-config and there isn't a way to force disable
  # without disabling spotlight support. So we just enable the feature for all systems.
  depends_on "icu4c@78"
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

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "jena", because: "both install `tdbbackup` binaries"
  conflicts_with "puzzles", because: "both install `net` binaries"

  resource "Parse::Yapp" do
    url "https://cpan.metacpan.org/authors/id/W/WB/WBRASWELL/Parse-Yapp-1.21.tar.gz"
    sha256 "3810e998308fba2e0f4f26043035032b027ce51ce5c8a52a8b8e340ca65f13e5"
  end

  # Fix the macOS build of the BSD-style `statvfs` code
  patch do
    url "https://gitlab.com/samba-team/samba/-/commit/5c855f9b484c99cedc224e1bf9536383cdf37057.diff"
    sha256 "f017f43545e587e7960e9fe22edad4c3dfa0d76b8edc969b7dcd5075a2f65a14"
    type :unofficial
    resolves "https://gitlab.com/samba-team/samba/-/merge_requests/4728"
  end

  # Link `LP_RESOLVE` against `resolv` for `res_search`, which is not in libc on macOS
  patch do
    url "https://gitlab.com/samba-team/samba/-/commit/398068b565f6c97f09a9a7d97d623362d4e75b0c.diff"
    sha256 "5f305220f57b8c1e7e70d217c71902b574882d0e68025974c627b49e8448e6bd"
    type :unofficial
    resolves "https://gitlab.com/samba-team/samba/-/merge_requests/4728"
  end

  # Give macOS libraries `@rpath` install names so installed files don't reference the build tree
  patch do
    url "https://gitlab.com/samba-team/samba/-/commit/0da9389015101a855f4230a340165347f3f7b99c.diff"
    sha256 "089018252c79648a6e8227b5e05c2c859a211a60f1b30b0333606256e1e7f68d"
    type :unofficial
    resolves "https://gitlab.com/samba-team/samba/-/merge_requests/4729"
  end

  def install
    # Skip building test that fails on ARM with error: initializer element is not a compile-time constant
    inreplace "lib/ldb/wscript", /\('test_ldb_comparison_fold',$/, "\\0 enabled=False," if Hardware::CPU.arm?

    # avoid `perl module "Parse::Yapp::Driver" not found` error on macOS 10.xx (not required on 11)
    if !OS.mac? || MacOS.version < :big_sur
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"
      resource("Parse::Yapp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
        system "make"
        system "make", "install"
      end
    end
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/private" if OS.linux?

    bundled_libs_list = []
    # Upstream (https://github.com/lxin/quic) has no tagged releases, so we would have to add an arbitrary
    # commit as a resource. That's not really better than just using the vendored copy. Consider breaking
    # it out into a resource or formula once tagged releases become available.
    bundled_libs_list << "libquic" if OS.linux?
    bundled_libs = bundled_libs_list.empty? ? "NONE" : bundled_libs_list.join(",")

    system "./configure",
           "--bundled-libraries=#{bundled_libs}",
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
           "--libdir=#{lib}",
           "--sysconfdir=#{etc}",
           "--localstatedir=#{var}"
    system "make"
    system "make", "install"
    return unless OS.mac?

    # macOS has its own SMB daemon as /usr/sbin/smbd, so rename our smbd to samba-dot-org-smbd to avoid conflict.
    # samba-dot-org-smbd is used by qemu.rb .
    # Rename profiles as well to avoid conflicting with /usr/bin/profiles
    mv sbin/"smbd", sbin/"samba-dot-org-smbd"
    mv bin/"profiles", bin/"samba-dot-org-profiles"
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid conflicting with macOS system binaries, some files were installed with non-standard name:
        - smbd:     #{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd
        - profiles: #{HOMEBREW_PREFIX}/bin/samba-dot-org-profiles
      EOS
    end
  end

  test do
    smbd = if OS.mac?
      sbin/"samba-dot-org-smbd"
    else
      sbin/"smbd"
    end

    system smbd, "--build-options", "--configfile=/dev/null"
    system smbd, "--version"

    mkdir_p "samba/state"
    mkdir_p "samba/data"
    (testpath/"samba/data/hello").write "hello"

    # mimic smb.conf generated by qemu
    # https://github.com/qemu/qemu/blob/v6.0.0/net/slirp.c#L862
    (testpath/"smb.conf").write <<~CONF
      [global]
      private dir=#{testpath}/samba/state
      interfaces=127.0.0.1
      bind interfaces only=yes
      pid directory=#{testpath}/samba/state
      lock directory=#{testpath}/samba/state
      state directory=#{testpath}/samba/state
      cache directory=#{testpath}/samba/state
      ncalrpc dir=#{testpath}/samba/state/ncalrpc
      log file=#{testpath}/samba/state/log.smbd
      smb passwd file=#{testpath}/samba/state/smbpasswd
      security = user
      map to guest = Bad User
      load printers = no
      printing = bsd
      disable spoolss = yes
      usershare max shares = 0
      [test]
      path=#{testpath}/samba/data
      read only=no
      guest ok=yes
      force user=#{ENV["USER"]}
    CONF

    port = free_port
    spawn smbd, "--debug-stdout", "-F", "--configfile=smb.conf", "--port=#{port}", "--debuglevel=4", in: "/dev/null"

    sleep 5
    mkdir_p "got"
    system bin/"smbclient", "-p", port.to_s, "-N", "//127.0.0.1/test", "-c", "get hello #{testpath}/got/hello"
    assert_equal "hello", (testpath/"got/hello").read
  end
end