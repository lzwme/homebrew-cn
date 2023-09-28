class Quictls < Formula
  desc "TLS/SSL and crypto library with QUIC APIs"
  homepage "https://github.com/quictls/openssl"
  url "https://ghproxy.com/https://github.com/quictls/openssl/archive/refs/tags/openssl-3.1.2-quic1.tar.gz"
  version "3.1.2-quic1"
  sha256 "1651412ec136a693fcc84c77df664ca0dc0495eab2785afa2c7ba064a00fb1b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^openssl[._-]v?(\d(?:\.\d)+[+._-]quic\d*)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e7573f3d557754e41b30e9db14bfef8ffdef2b9330b7e5b52ba1e6f443325b12"
    sha256 arm64_ventura:  "4ffa722fb1756ea0c30d697a5dffc811e129062346e50e40ff976e31a0111745"
    sha256 arm64_monterey: "1cd25250ea9d032dfd5dbc7f7118d9a287935541eadef9019fd3cbfec877bb33"
    sha256 arm64_big_sur:  "b00e7991d2420650932db6f72d1d947ec9bffa1715df40ddd5107e90250b5166"
    sha256 sonoma:         "4e8e48ef59b17d2c33e606a3ca6da3517f8083c9d341c78ebc58f36ae3f6dabe"
    sha256 ventura:        "8eb411af2ce71bc976ba60aa1a8e35c450e6fbf3e2bdb7d30b2d4ac4a1d35baf"
    sha256 monterey:       "5c3890ccf66c1177ea60ee444821a5592d5e6c372f85aa264ea69a508ea598ae"
    sha256 big_sur:        "03714b1a508f5d85cc79239ce88566396a3a9e680a150aa4aa29b477aa7538bb"
    sha256 x86_64_linux:   "7564b141c8b8ce127fda129677342c85c9ea0ba18b4768df2c24f5bdf8a1dc31"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.44.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.44.tar.gz"
      sha256 "7eb591ea6b499ece6745ff3e80e60cee669f0037f9ccbc4e4511425f593e5297"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302195.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302195.tar.gz"
      sha256 "b390bb23592e0b946c95adbb3c30b11bc634a286b2847be611ad929c57e39a6c"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
          system "make", "install"
        end
      end
    end

    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = Formula["perl"].opt_bin/"perl" if which("perl") == Formula["perl"].opt_bin/"perl"

    # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
    # SSLv3 & zlib are off by default with 1.1.0 but this may not
    # be obvious to everyone, so explicitly state it for now to
    # help debug inevitable breakage.
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{quictlsdir}
      --libdir=#{lib}
      no-ssl3
      no-ssl3-method
      no-zlib
    ]

    if OS.linux?
      args += (ENV.cflags || "").split
      args += (ENV.cppflags || "").split
      args += (ENV.ldflags || "").split
    end

    if OS.mac?
      args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    quictlsdir.mkpath
    system "perl", "./Configure", *args
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def quictlsdir
    etc/"quictls"
  end

  def post_install
    rm_f quictlsdir/"cert.pem"
    quictlsdir.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{quictlsdir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate pkgetc/"openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end