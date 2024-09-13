class Quictls < Formula
  desc "TLSSSL and crypto library with QUIC APIs"
  homepage "https:github.comquictlsopenssl"
  url "https:github.comquictlsopensslarchiverefstagsopenssl-3.1.7-quic1.tar.gz"
  version "3.1.7-quic1"
  sha256 "e7e514ea033c290f09c7250dd43a845bc1e08066b793274f3ad3fe04c76a5206"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^openssl[._-]v?(\d(?:\.\d)+[+._-]quic\d*)$i)
  end

  bottle do
    sha256 arm64_sequoia:  "98c6083da11677530ffead197c3874fa6a279628a73adb964179f04e7a776cb1"
    sha256 arm64_sonoma:   "73ddf68c9960767751d2c35c0e880fa2ceeeb4f54b3fc9b23bcc0acf423d249f"
    sha256 arm64_ventura:  "d3078ce0ffe8788999f7d8544c2a87c636fdd2e179c9c43c48a5621bd0b72173"
    sha256 arm64_monterey: "2106c4a0c2355ce50521e2e4f5f310944ae80368b415c79c7c965fdfd603d9fc"
    sha256 sonoma:         "dd3116df5fe47c4d55cc7c51df5becbca99942f587cb97b26f246a468f69e8d6"
    sha256 ventura:        "3882bfe6a6745e400edf6483ffb629095a1e239176b5d53830ed4c2e8b2697d4"
    sha256 monterey:       "76595d8637073ff8c6757c9d958a0b0256a677d4ded70e98f8b78ee44e0b1b33"
    sha256 x86_64_linux:   "d087162e7c966ef053b5f6f3fb4b1186c2aa0bb482259041a37a9a166419ec76"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.50.tar.gz"
      sha256 "79b6acdc444f1924cd4c2e9ed868bdc6e09580021aca8ff078ede2ffef8a6f54"
    end

    resource "Test::More" do
      url "https:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302201.tar.gz"
      sha256 "956185dc96c1f2942f310a549a2b206cc5dd1487558f4e36d87af7a8aacbc87c"
    end

    resource "ExtUtils::MakeMaker" do
      url "https:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

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
    ENV["PERL"] = Formula["perl"].opt_bin"perl" if which("perl") == Formula["perl"].opt_bin"perl"

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
    system "perl", ".Configure", *args
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def quictlsdir
    etc"quictls"
  end

  def post_install
    rm(quictlsdir"cert.pem") if (quictlsdir"cert.pem").exist?
    quictlsdir.install_symlink Formula["ca-certificates"].pkgetc"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{quictlsdir}certs

      and run
        #{opt_bin}c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate pkgetc"openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end