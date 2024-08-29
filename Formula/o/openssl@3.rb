class OpensslAT3 < Formula
  desc "Cryptography and SSLTLS Toolkit"
  homepage "https:openssl-library.org"
  url "https:github.comopensslopensslreleasesdownloadopenssl-3.3.1openssl-3.3.1.tar.gz"
  mirror "http:fresh-center.netlinuxmiscopenssl-3.3.1.tar.gz"
  sha256 "777cd596284c883375a2a7a11bf5d2786fc5413255efab20c50d6ffe6d020b7e"
  license "Apache-2.0"

  livecheck do
    url "https:openssl-library.orgsource"
    regex(href=.*?openssl[._-]v?(3(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "f0dc71fe6bb0ce1618acd7c4a68dcaf5d725bd2beb2b703c1992e8ba91b5c7c7"
    sha256 arm64_ventura:  "b39924b6b665832c7dcb46e99a5e257ca3e932313c528086631769933c78d9a0"
    sha256 arm64_monterey: "4cde73aab115e6c814c8a98488c742a622f26ee8d7b2cfb422b69eccbde8148f"
    sha256 sonoma:         "5bf5e00bd262cb450490fad19b167cb684dfe8ba9c4f3dfa079871f437cac84a"
    sha256 ventura:        "c3148aa9a81e9cd5e05f6171a9febdbe2de43a9ce1d9b8dc58bf041ce112c7fc"
    sha256 monterey:       "f18b36971ea359ccc7d69b5b4a7ab22ccf363c45a51417d984301700c1c73fdf"
    sha256 x86_64_linux:   "63d76975c55730b4f46dd00ed325de913e8319b7fa6dae1e03eb11cc86514c7a"
  end

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.48.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidLLELEONTTest-Harness-3.48.tar.gz"
      sha256 "e73ff89c81c1a53f6baeef6816841b89d3384403ad97422a7da9d1eeb20ef9c5"
    end

    resource "Test::More" do
      url "https:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302198.tar.gz"
      mirror "http:cpan.metacpan.orgauthorsidEEXEXODISTTest-Simple-1.302198.tar.gz"
      sha256 "1dc07bcffd23e49983433c948de3e3f377e6e849ad7fe3432c717fa782024faa"
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

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      --libdir=lib
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
    # AF_ALG support isn't always enabled (e.g. some containers), which breaks the tests.
    # AF_ALG is a kernel feature and failures are unlikely to be issues with the formula.
    system "make", "test", "TESTS=-test_afalg"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| openssldirsubdir".keepme" }
  end

  def openssldir
    etc"openssl@3"
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