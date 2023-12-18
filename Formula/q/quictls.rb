class Quictls < Formula
  desc "TLSSSL and crypto library with QUIC APIs"
  homepage "https:github.comquictlsopenssl"
  url "https:github.comquictlsopensslarchiverefstagsopenssl-3.1.4-quic1.tar.gz"
  version "3.1.4-quic1"
  sha256 "4bf990243d6aa39b8befa0c399834415842912ef67f88bef98e74dc619469618"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^openssl[._-]v?(\d(?:\.\d)+[+._-]quic\d*)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "b935d3c20432ee4c30287c619ef15e7eb04c53375cfd910a0094c20edf0aa5e9"
    sha256 arm64_ventura:  "f06a54674f3eeff0a011313c8cbf778315a2d555c1aaa9799801dcba4bab5b75"
    sha256 arm64_monterey: "8072b1e4965fe8b271539f927a03d550758268e8841842f6a4b6298da5505140"
    sha256 sonoma:         "28b6d5895cb7fbe3a9d09ec1908526f71b91a50754d825108d8b9a61b43ec2e2"
    sha256 ventura:        "80fd4424f7bee7218208a8153218e2fc4493db774ec79bd2496dabd8d598bfda"
    sha256 monterey:       "3b8c85997c5cfe55f90facef8aff805465e23c2c661b294fac88b74df6c344fe"
    sha256 x86_64_linux:   "63edb370864adcb173929b83dc3e2a6d56386ada55f56f0657d41b611b4e3270"
  end

  keg_only "it conflicts with OpenSSL"

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.44.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.44.tar.gz"
      sha256 "7eb591ea6b499ece6745ff3e80e60cee669f0037f9ccbc4e4511425f593e5297"
    end

    resource "Test::More" do
      url "https:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302195.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302195.tar.gz"
      sha256 "b390bb23592e0b946c95adbb3c30b11bc634a286b2847be611ad929c57e39a6c"
    end

    resource "ExtUtils::MakeMaker" do
      url "https:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
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
    rm_f quictlsdir"cert.pem"
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