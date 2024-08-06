class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.43.tar.bz2"
  sha256 "a3b34c40f455d93054d33cf4cf2a8ce41149d499eca2fbb759619de04822d453"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "85de04bd6035588e6bd336b8f451ca26a63db2ad985df5a31fb64870555ef85c"
    sha256 arm64_ventura:  "0dde16fd39c55f1c373363f1711717b1a6914820e421636fd4cf11654593f179"
    sha256 arm64_monterey: "0e4c4b6e78d3f0f1c62347ebd72b5bdace16a9b4ba41460b403f458ae1eea0e8"
    sha256 sonoma:         "a27cd2401fb29df75d64b516e8603d9b88e9896f712b7c43c7ba7233d808e633"
    sha256 ventura:        "b796d3a08251a0c870e18b75bd338d559506dab1e380164d51d5e4fc4b7ba6e0"
    sha256 monterey:       "8d5258a0878509c5c56721c263140bf692761183243ad05eaf4658846e2c4b7e"
    sha256 x86_64_linux:   "ba4ed9a84afd6854ead05ad72d2ad1f13563e88eea40294853c2b7c498ffb3f9"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--enable-symcryptrun",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end