class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.42.tar.bz2"
  sha256 "9189fbd4ec83ad243a4e499d5cb7fe72e4532176817e5ea880ed36a71dd82557"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f6ada55cdb89e967471ae13ae1112babbc5448030200989620700db04778a921"
    sha256 arm64_ventura:  "add419ba0ef86be97e5c1b04eb9047418d74ac7a8ac5b9ce4a465ac455e4b4a9"
    sha256 arm64_monterey: "45a52dcf028778a013ef759596839b09f1d79e4f6883207a45e83a4ca76f54bb"
    sha256 sonoma:         "df3458b4787f7594563e01503aad833b32ad51ac80b306c1496ee1797c9d0cef"
    sha256 ventura:        "4c141c693d053bf4ec78d8538fbf29e83bb0990db9f9c32904cd00d42c9accca"
    sha256 monterey:       "6abbed28e58ec984661998168edf06c74f18f1a80e1ffcc2c52662baeb00718e"
    sha256 x86_64_linux:   "a6c8b1c57c926beaa04ec59adea0ace839183dfc3ebbad65622925e1a90ca87b"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "sqlite" => :build

  on_linux do
    depends_on "libidn"
  end

  def install
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