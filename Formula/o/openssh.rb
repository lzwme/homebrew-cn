class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https:www.openssh.com"
  url "https:cdn.openbsd.orgpubOpenBSDOpenSSHportableopenssh-9.5p1.tar.gz"
  mirror "https:cloudflare.cdn.openbsd.orgpubOpenBSDOpenSSHportableopenssh-9.5p1.tar.gz"
  version "9.5p1"
  sha256 "f026e7b79ba7fb540f75182af96dc8a8f1db395f922bbc9f6ca603672686086b"
  license "SSH-OpenSSH"

  livecheck do
    url "https:ftp.openbsd.orgpubOpenBSDOpenSSHportable"
    regex(href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "b50530ed5e22e2be7650edc28d8b94ba72f274ca73c828ff93fabe49efd47b71"
    sha256 arm64_ventura:  "5b8d1bfebc8e8323bfd2363075d578ebbe63176276f1fcf3ee89fb85473bd3c5"
    sha256 arm64_monterey: "624975ac10b48d802dabb883cd8c9e3465a3b0428ffb59cc243f38b8cf594c90"
    sha256 sonoma:         "fb69dc459f50c70582ff14599bc8474ccdffe59e614080701e4edf5efdaee8f1"
    sha256 ventura:        "fc6a1d4c76072c7dcc06e4090f8c3cf3aff7fdc9f9d051825c724e4b2015f026"
    sha256 monterey:       "97a641b18430ea4bdf908f8b2ec802ed55ad7a12ffd0a0b026a3e243fb394260"
    sha256 x86_64_linux:   "d3f190725051f8963f37c59cb868bde19b950397a0dc5d7ebd96977bcd18e522"
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https:archive.ishSB6d#10%25

  depends_on "pkg-config" => :build
  depends_on "ldns"
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build
  uses_from_macos "lsof" => :test
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    # Both these patches are applied by Apple.
    # https:github.comapple-oss-distributionsOpenSSHblobmainopensshsandbox-darwin.c#L66
    patch do
      url "https:raw.githubusercontent.comHomebrewpatches1860b0a745f1fe726900974845d1b0dd3c3398d6opensshpatch-sandbox-darwin.c-apple-sandbox-named-external.diff"
      sha256 "d886b98f99fd27e3157b02b5b57f3fb49f43fd33806195970d4567f12be66e71"
    end

    # https:github.comapple-oss-distributionsOpenSSHblobmainopensshsshd.c#L532
    patch do
      url "https:raw.githubusercontent.comHomebrewpatchesd8b2d8c2612fd251ac6de17bf0cc5174c3aab94copensshpatch-sshd.c-apple-sandbox-named-external.diff"
      sha256 "3505c58bf1e584c8af92d916fe5f3f1899a6b15cc64a00ddece1dc0874b2f78f"
    end
  end

  on_linux do
    depends_on "linux-pam"
  end

  resource "com.openssh.sshd.sb" do
    url "https:raw.githubusercontent.comapple-oss-distributionsOpenSSHOpenSSH-268.100.4com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  def install
    if OS.mac?
      ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

      # Ensure sandbox profile prefix is correct.
      # We introduce this issue with patching, it's not an upstream bug.
      inreplace "sandbox-darwin.c", "@PREFIX@shareopenssh", etc"ssh"

      # FIXME: `ssh-keygen` errors out when this is built with optimisation.
      # Reported upstream at https:bugzilla.mindrot.orgshow_bug.cgi?id=3584
      # Also can segfault at runtime: https:github.comHomebrewhomebrew-coreissues135200
      if Hardware::CPU.intel? && DevelopmentTools.clang_build_version == 1403
        inreplace "configure", "-fzero-call-used-regs=all", "-fzero-call-used-regs=used"
      end
    end

    args = *std_configure_args + %W[
      --sysconfdir=#{etc}ssh
      --with-ldns
      --with-libedit
      --with-kerberos5
      --with-pam
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-security-key-builtin
    ]

    args << "--with-privsep-path=#{var}libsshd" if OS.linux?

    system ".configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin"ssh" => "slogin"

    buildpath.install resource("com.openssh.sshd.sb")
    (etc"ssh").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"
  end

  test do
    assert_match "OpenSSH_", shell_output("#{bin}ssh -V 2>&1")

    port = free_port
    fork { exec sbin"sshd", "-D", "-p", port.to_s }
    sleep 2
    assert_match "sshd", shell_output("lsof -i :#{port}")
  end
end