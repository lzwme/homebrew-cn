class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.12rakudo-star-2024.12.tar.gz"
  sha256 "a38aa8b02a7792ed9919d75e224bce84493bb7ed34ee0508382b29279f53623b"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sequoia: "523d234bf059e1ea81d7633b3caafd94973b9e42f1df746a694b1ccd0d2e1368"
    sha256 arm64_sonoma:  "6413d986f8f733757258d15ab38de86f8046fb8c312f4d107212b8ab3bf5e6f0"
    sha256 arm64_ventura: "a1ca5dbba61fe6a6c8b2e333e59f5db3e5e7751d4ac07a212599ea7b65dc2734"
    sha256 sonoma:        "766709a05b53bcad5ee13ce700159a589ff6ccf6fcb68d0e11c3235f78542a2a"
    sha256 ventura:       "2030e6969c29ad77c123946f46172e42786a4cb21140aab0bc9ccee0f9bb0088"
    sha256 x86_64_linux:  "94d39d2e72eb57c4afc4a1bb4733b6cae96d77618cc4a997b495e7cbd728dca7"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c@76"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"
  uses_from_macos "libffi", since: :catalina

  conflicts_with "moar", because: "both install `moar` binaries"
  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    if !OS.mac? || MacOS.version < :catalina
      libffi = Formula["libffi"]
      ENV.remove "CPPFLAGS", "-I#{libffi.include}"
      ENV.prepend "CPPFLAGS", "-I#{libffi.lib}libffi-#{libffi.version}include"
    end

    ENV.deparallelize # An intermittent race condition causes random build failures.

    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"

    # openssl module's brew --prefix openssl probe fails so
    # set value here
    openssl_prefix = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_PREFIX"] = openssl_prefix.to_s

    system "binrstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in shareperl{site|vendor}bin, so we need to symlink it too.
    bin.install_symlink (share"perl6vendorbin").children
    bin.install_symlink (share"perl6sitebin").children

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    share.install prefix"man" if (prefix"man").directory?
  end

  test do
    out = shell_output("#{bin}raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end