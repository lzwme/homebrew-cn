class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.1p1.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.1p1.tar.gz"
  version "10.1p1"
  sha256 "b9fc7a2b82579467a6f2f43e4a81c8e1dfda614ddb4f9b255aafd7020bbf0758"
  license "SSH-OpenSSH"
  revision 1

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/"
    regex(/href=.*?openssh[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "80ca0cc0b0ee77beb76226996067a7f32531eab664cc2fed17a5c4e5e01cb783"
    sha256 arm64_sequoia: "a49a24b8a86c3712f6ea4ef9da98dc56112fac509887d32b441f8617a787c2c6"
    sha256 arm64_sonoma:  "b23c3cdc18b9ba937c76f13a75d81c2c6b4d8e3fea0acd8bc035c2c35e027eb2"
    sha256 sonoma:        "02dc5bdd874de88761894d459ad093b5dcfe8e69ed9526e98b75f509a703c3f8"
    sha256 arm64_linux:   "f028097be5733c39e032f32c2c17586ca4aa11394d998f11edcc4f27e1a08c76"
    sha256 x86_64_linux:  "133fc0cd700bce16e7a6659c51a995cbcb8091ac5142a990b28b4e551e348323"
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://archive.is/hSB6d#10%25

  depends_on "pkgconf" => :build
  depends_on "ldns"
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build
  uses_from_macos "lsof" => :test
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  resource "com.openssh.sshd.sb" do
    url "https://ghfast.top/https://raw.githubusercontent.com/apple-oss-distributions/OpenSSH/OpenSSH-268.100.4/com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  # FIXME: non-interactive sudo/stdio is broken (e.g. used by ansible)
  # Upstream Issue (already fixed): https://bugzilla.mindrot.org/show_bug.cgi?id=3872
  # Can be removed if the patch is included in the next release
  patch do
    url "https://anongit.mindrot.org/openssh.git/patch/?id=beae06f56e0d0a66ca535896149d5fb0b2e8a1b4"
    sha256 "3dc44a12e6452df72331756c1eb3fdb78f1bd40634713728258cc1882fc86200"
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?

    args = %W[
      --sysconfdir=#{etc}/ssh
      --with-ldns
      --with-libedit
      --with-kerberos5
      --with-pam
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-security-key-builtin
    ]

    args << "--with-privsep-path=#{var}/lib/sshd" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"

    buildpath.install resource("com.openssh.sshd.sb")
    (etc/"ssh").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"

    # Don't hardcode Cellar paths in configuration files
    inreplace etc/"ssh/sshd_config", prefix, opt_prefix
  end

  test do
    (etc/"ssh").find do |pn|
      next unless pn.file?

      refute_match HOMEBREW_CELLAR.to_s, pn.read
    end

    assert_match "OpenSSH_", shell_output("#{bin}/ssh -V 2>&1")

    port = free_port
    spawn sbin/"sshd", "-D", "-p", port.to_s
    sleep 2
    assert_match "sshd", shell_output("lsof -i :#{port}")
  end
end