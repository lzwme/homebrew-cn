class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl-library.org"
  url "https://ghfast.top/https://github.com/openssl/openssl/releases/download/openssl-3.6.3/openssl-3.6.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/openssl-3.6.3.tar.gz"
  sha256 "243a86649cf6f23eeb6a2ff2456e09e5d77dd9018a54d3d96b0c6bdd6ba6c7f1"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://openssl-library.org/source/"
    regex(/href=.*?openssl[._-]v?(3(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "235c30e706c96896ce2be9a38032bf54f46b2aaa1e7193d3cdd73446124fc7be"
    sha256 arm64_sequoia: "638cbf9a395d2a3e97465c99997705736e228cd4c98db254c108946236c1de29"
    sha256 arm64_sonoma:  "3e4d9ff94169f479e221cce2a20249c3969a8ce4caec036f1c386d839b0cf5f4"
    sha256 tahoe:         "993f3d2010d96601e842bcb2691cd02bea288993c7a48e785ff8649da8e00d07"
    sha256 sequoia:       "b44eb2badf15edf527f584f31483993fdb9e006005d704ef6641f05aa43538b3"
    sha256 sonoma:        "f81141067a5482b149b6c936fc4c901d19e784a1800810da2f4f7a4ddeaf839d"
    sha256 arm64_linux:   "26d8dbc4880e3e4c95639d72c194b03eeb91b302b847680cdbb2f5c66e42e79a"
    sha256 x86_64_linux:  "2f71820c8bec00c0e957dc5f20e3b0a651ec07b9c0540d08397b69df2478e3d5"
  end

  depends_on "ca-certificates" => :no_linkage

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.52.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.52.tar.gz"
      sha256 "8fe65cfc0261ed3c8a4395f0524286f5719669fe305f9b03b16cf3684d62cd70"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302222.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302222.tar.gz"
      sha256 "7cf84a18d6c9450e53ae8b4de5d5fa32c9fe99f3cebbe408fe59433f19921ec2"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.78.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.78.tar.gz"
      sha256 "43b33c20f8d82dba7cc48f8cd702f8fc9811e9d07880886dfd31b7077bd4a3a6"
    end
  end

  link_overwrite "bin/c_rehash", "bin/openssl", "include/openssl/*"
  link_overwrite "lib/libcrypto*", "lib/libssl*"
  link_overwrite "lib/pkgconfig/libcrypto.pc", "lib/pkgconfig/libssl.pc", "lib/pkgconfig/openssl.pc"
  link_overwrite "share/doc/openssl/*", "share/man/man*/*ssl"

  # Backport commits to avoid test timing failures
  patch do
    url "https://github.com/openssl/openssl/commit/9061e9381306a053908177aca8509c262015cdf3.patch?full_index=1"
    sha256 "9f68feae9abfaabe65f79d2877f3dde7aa0428c669ed6af45dc193544268438e"
  end
  patch do
    url "https://github.com/openssl/openssl/commit/2e2438b494e7f661be5212e4732f7fab86bf6303.patch?full_index=1"
    sha256 "543a5998951fe540444642123398ffaa6306938be573f95c0bc915f1e6af7a36"
  end
  patch do
    url "https://github.com/openssl/openssl/commit/ea598f5dd23f1d64d8952e20fcf95d9f3a21d654.patch?full_index=1"
    sha256 "05bb323a3495d68961fa8cf7a989edfb0fa6e6dcc7ccdcc4e55a4e3f946d2762"
  end
  patch do
    url "https://github.com/openssl/openssl/commit/cffb97915813aeeef58ee9a0d33c05d3d45e1fe6.patch?full_index=1"
    sha256 "fc34b4bf106c44a89ded746e35d587d73e8485393a93b52110ba95b06717dd69"
  end

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
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"

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
    ENV["PERL"] = formula_opt_bin("perl")/"perl" if which("perl") == formula_opt_bin("perl")/"perl"

    arch_args = []
    if OS.mac?
      arch_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    openssldir.mkpath
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    # AF_ALG support isn't always enabled (e.g. some containers), which breaks the tests.
    # AF_ALG is a kernel feature and failures are unlikely to be issues with the formula.
    # `test_quick_tserver` intermittently fails on CI.
    # It has been reported upstream with no resolution in over a year, so we skip it.
    system "make", "HARNESS_JOBS=#{ENV.make_jobs}", "test", "TESTS=-test_afalg -test_quic_tserver"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| openssldir/subdir/".keepme" }
  end

  def openssldir
    etc/"openssl@3"
  end

  def post_install
    rm(openssldir/"cert.pem") if (openssldir/"cert.pem").exist?
    openssldir.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash

      OpenSSL 3.6 is only supported until 2026-11-01 so the `openssl@3`
      formula will be downgraded to OpenSSL 3.5 (LTS) in a future update.
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_path_exists pkgetc/"openssl.cnf", "OpenSSL requires the .cnf file for some functionality"
    assert_path_exists openssldir/"certs", "OpenSSL throws confusing errors when this directory is missing"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end

    # Invalid cert from superfish.badssl.com
    bad_cert = <<~PEM
      -----BEGIN CERTIFICATE-----
      MIIC9TCCAl6gAwIBAgIJAK5EmlK7Klu5MA0GCSqGSIb3DQEBCwUAMFsxGDAWBgNV
      BAoTD1N1cGVyZmlzaCwgSW5jLjELMAkGA1UEBxMCU0YxCzAJBgNVBAgTAkNBMQsw
      CQYDVQQGEwJVUzEYMBYGA1UEAxMPU3VwZXJmaXNoLCBJbmMuMB4XDTE4MDUxNjE3
      MTUyM1oXDTIwMDUxNTE3MTUyM1owajELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNh
      bGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDzANBgNVBAoMBkJhZFNT
      TDEdMBsGA1UEAwwUc3VwZXJmaXNoLmJhZHNzbC5jb20wggEiMA0GCSqGSIb3DQEB
      AQUAA4IBDwAwggEKAoIBAQDCBOz4jO4EwrPYUNVwWMyTGOtcqGhJsCK1+ZWesSss
      dj5swEtgTEzqsrTAD4C2sPlyyYYC+VxBXRMrf3HES7zplC5QN6ZnHGGM9kFCxUbT
      Focnn3TrCp0RUiYhc2yETHlV5NFr6AY9SBVSrbMo26r/bv9glUp3aznxJNExtt1N
      wMT8U7ltQq21fP6u9RXSM0jnInHHwhR6bCjqN0rf6my1crR+WqIW3GmxV0TbChKr
      3sMPR3RcQSLhmvkbk+atIgYpLrG6SRwMJ56j+4v3QHIArJII2YxXhFOBBcvm/mtU
      mEAnhccQu3Nw72kYQQdFVXz5ZD89LMOpfOuTGkyG0cqFAgMBAAGjLjAsMAkGA1Ud
      EwQCMAAwHwYDVR0RBBgwFoIUc3VwZXJmaXNoLmJhZHNzbC5jb20wDQYJKoZIhvcN
      AQELBQADgYEAKgHH4VD3jfwzxvtWTmIA1nwK+Fjqe9VFXyDwXiBnhqDwJp9J+/2y
      r7jbXfEKf7WBS6OmnU+HTjxUCFx2ZnA4r7dU5nIsNadKEDVHDOvYEJ6mXHPkrvlt
      k79iHC0DJiJX36BTXcU649wKEVjgX/kT2yy3YScPdBoN0vtzPN3yFsQ=
      -----END CERTIFICATE-----
    PEM
    output = pipe_output("#{bin}/openssl verify 2>&1", bad_cert, 2)
    assert_match "verification failed", output
    refute_match "error:80000002", output
  end
end