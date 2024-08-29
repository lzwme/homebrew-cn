class OpensslAT30 < Formula
  desc "Cryptography and SSLTLS Toolkit"
  homepage "https:openssl-library.org"
  url "https:github.comopensslopensslreleasesdownloadopenssl-3.0.14openssl-3.0.14.tar.gz"
  sha256 "eeca035d4dd4e84fc25846d952da6297484afa0650a6f84c682e39df3a4123ca"
  license "Apache-2.0"

  livecheck do
    url "https:openssl-library.orgsource"
    regex(href=.*?openssl[._-]v?(3\.0(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "4b9d08a98550729ea96497e779d9439a665da53b1e4f7254a289057c8385d052"
    sha256 arm64_ventura:  "1ef02be64e1b21bd37602fda904fd62f4eb19a317e905e4e48c19512b00c6826"
    sha256 arm64_monterey: "06b6b04f2341cbfc62da8629b5a4d2387d32874d9f56b57cc94542c42c4b57c0"
    sha256 sonoma:         "18753268f80af56418e41cdadbf92d90c812bd568a215d29d8ecca5f755bdb69"
    sha256 ventura:        "07ade2749aa1aaf20456e56fe4122adb520a1bd11218f68f77037486b9159d95"
    sha256 monterey:       "85aa26b13c64c1ba59666bedabd0a76b91eafc6877f49c7ace3e495dd0f53252"
    sha256 x86_64_linux:   "8b749cbdf46421dca06c85c7ed018d2013c81d6c8f517dd54db8c3f9e1f6b972"
  end

  keg_only :versioned_formula

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.49_01.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.49_01.tar.gz"
      sha256 "0607cf6c34d6afe9f48b3e33ac75dbf229d99609709a559af4173284c54dfbde"
    end

    resource "Test::More" do
      url "https:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302199.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302199.tar.gz"
      sha256 "7b4b03cee7f9e928fe10e8a3efef02b2a286f0877979694b2a9ef99250bd8c5c"
    end

    resource "ExtUtils::MakeMaker" do
      url "https:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
    end
  end

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      --libdir=#{lib}
      no-ssl3
      no-ssl3-method
      no-zlib
    ]
    on_linux do
      args += (ENV.cflags || "").split
      args += (ENV.cppflags || "").split
      args += (ENV.ldflags || "").split
    end
    args
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath"libperl5"
      ENV.prepend_path "PATH", buildpath"bin"

      %w[ExtUtils::MakeMaker Test::Harness Test::More].each do |r|
        resource(r).stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
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

    arch_args = []
    if OS.mac?
      arch_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    openssldir.mkpath
    system "perl", ".Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| openssldirsubdir".keepme" }
  end

  def openssldir
    etc"openssl@3.0"
  end

  def post_install
    rm(openssldir"cert.pem") if (openssldir"cert.pem").exist?
    openssldir.install_symlink Formula["ca-certificates"].pkgetc"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{openssldir}certs

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