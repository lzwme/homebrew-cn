class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-4.2.0.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-4.2.0.tar.gz"
  sha256 "0f7dba44d7cb8df8d53f2cfbf1955254bc128e0089595f1aba2facfaee8408b2"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "85687f0b76c346c583c423c6805812639e1a8948fafa197c28428222d1955743"
    sha256 arm64_sequoia: "7dcc4e7c6e2c29af7f288d9e125bc44c3777c9ee766153591bc1c87e85647716"
    sha256 arm64_sonoma:  "9e42a44178f7d0479e42ae4fed172e368788abbd5b049d75336e5dd6b7822c98"
    sha256 sonoma:        "56c0432156bd7a807e25a3418a09cd9c03218c68a8f966cc45f3321f9df749ed"
    sha256 arm64_linux:   "f2ea5ddeebbd96e3c8ba17e75233efd6b328769c61372ce3e7d6f8530c804ef2"
    sha256 x86_64_linux:  "dd76c63493701593542603ad2d861ddb705b6dd89ed192fe1f75cb77036298fd"
  end

  head do
    url "https://github.com/libressl/portable.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssldir=#{etc}/libressl
      --sysconfdir=#{etc}/libressl
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the SystemRoots
      keychain. To add additional certificates (e.g. the certificates added in
      the System keychain), place .pem files in
        #{etc}/libressl/certs

      and run
        #{opt_bin}/openssl certhash #{etc}/libressl/certs
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise LibreSSL gets moody.
    assert_path_exists HOMEBREW_PREFIX/"etc/libressl/openssl.cnf",
"LibreSSL requires the .cnf file for some functionality"

    # Check LibreSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end