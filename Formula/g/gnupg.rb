class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.6.tar.bz2"
  sha256 "95acfafda7004924a6f5c901677f15ac1bda2754511d973bb4523e8dd840e17a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "504f8f29547995be5fef21f91769f05e1b2e317c424d3d481d3e1c69561f93b6"
    sha256 arm64_sonoma:  "5a23f8f2c150986e2e727a25bc42c12c5f89455bc27a213dcfa98289df377bf2"
    sha256 arm64_ventura: "31f920052dda3ede08d6a75b56c7b38cdb41a0964ab18305ebfc70ac55bbcc37"
    sha256 sonoma:        "e71ab7138942ea33cac896389aa8e82a4583d0ac5c1691d816e3671bd9327e7b"
    sha256 ventura:       "e6106c117ccdceeadbad2f16a6ddb551e93b08be6c60e9fc5af615ec23c26e3d"
    sha256 x86_64_linux:  "861b48d7bc2aa8e2a81f6c300d425ff2453ffb5bc948bc58cf1bdf1d93bd13ec"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline"

  uses_from_macos "bzip2"
  uses_from_macos "openldap"
  uses_from_macos "sqlite", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  # Backport fix for missing unistd.h
  patch do
    url "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=patch;h=1d5cfa9b7fd22e1c46eeed5fa9fed2af6f81d34f"
    sha256 "610d0c50004e900f1310f58255fbf559db641edf22abb86a6f0eb6c270959a5d"
  end

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

    mkdir "build" do
      system "../configure", "--disable-silent-rules",
                             "--enable-all-tests",
                             "--sysconfdir=#{etc}",
                             "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                             *std_configure_args
      system "make"
      system "make", "check"
      system "make", "install"
    end

    # Configure scdaemon as recommended by upstream developers
    # https://dev.gnupg.org/T5415#145864
    if OS.mac?
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~CONF
        disable-ccid
      CONF
      pkgetc.install "scdaemon.conf"
    end
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG

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