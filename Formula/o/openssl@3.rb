class OpensslAT3 < Formula
  desc "Cryptography and SSLTLS Toolkit"
  homepage "https:openssl.org"
  url "https:www.openssl.orgsourceopenssl-3.2.1.tar.gz"
  mirror "https:www.mirrorservice.orgsitesftp.openssl.orgsourceopenssl-3.2.1.tar.gz"
  mirror "https:www.openssl.orgsourceold3.2openssl-3.2.1.tar.gz"
  mirror "https:www.mirrorservice.orgsitesftp.openssl.orgsourceold3.2openssl-3.2.1.tar.gz"
  mirror "http:www.mirrorservice.orgsitesftp.openssl.orgsourceopenssl-3.2.1.tar.gz"
  mirror "http:www.mirrorservice.orgsitesftp.openssl.orgsourceold3.2openssl-3.2.1.tar.gz"
  sha256 "83c7329fe52c850677d75e5d0b0ca245309b97e8ecbcfdc1dfdc4ab9fac35b39"
  license "Apache-2.0"

  livecheck do
    url "https:www.openssl.orgsource"
    regex(href=.*?openssl[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "c2a712e6f567969c05d1a1e369f44db38f9449a95ba0da3a458129274927a84a"
    sha256 arm64_ventura:  "9bb2dbdec18c6d93a571768733a687b76ace38d41890830fe29750e21199ff60"
    sha256 arm64_monterey: "faa80599f00a1da75b643542048737b37b1d70f007764ade599276aa85dfcb4b"
    sha256 sonoma:         "81bf1c32858d32b1ac7bec3ddbe027208dc77689301b40b6d5e3b3e1e3de131e"
    sha256 ventura:        "8d686e92b2c6960b7d6ed6523ad4260c608d4dedb555421580a1ae0d828d5236"
    sha256 monterey:       "f2f4d0a1ce994696e8dbca6bca86518aff563fd8747060e7caa398f103a84475"
    sha256 x86_64_linux:   "31969bedc346be02a767ecf22de1b8d713425a57f3f2e4b636576b692ee60216"
  end

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.48.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.48.tar.gz"
      sha256 "e73ff89c81c1a53f6baeef6816841b89d3384403ad97422a7da9d1eeb20ef9c5"
    end

    resource "Test::More" do
      url "https:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302196.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302196.tar.gz"
      sha256 "020e71da0a479b2d2546304ce6bd23fb9dd428df7d4e161d19612fc1f406fd9f"
    end

    resource "ExtUtils::MakeMaker" do
      url "https:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidBBIBINGOSExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
    end
  end

  link_overwrite "binc_rehash", "binopenssl", "includeopenssl*"
  link_overwrite "liblibcrypto*", "liblibssl*"
  link_overwrite "libpkgconfiglibcrypto.pc", "libpkgconfiglibssl.pc", "libpkgconfigopenssl.pc"
  link_overwrite "sharedocopenssl*", "sharemanman**ssl"

  # Fix multi-certificate PEM loading.
  # Remove with OpenSSL 3.2.1.
  patch do
    url "https:github.comopensslopensslcommitcafccb768be5b8f5c21852764f7b2863b6f5e204.patch?full_index=1"
    sha256 "fd1628e55a6db01324bd4acf693316999b94de45b56c7460f92b15e65199bb6e"
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
  end

  def openssldir
    etc"openssl@3"
  end

  def post_install
    rm_f openssldir"cert.pem"
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