class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.06rakudo-star-2024.06.tar.gz"
  sha256 "79204e08587ce6c506912ecca2df6f1ca8f2c8377767f41036f51c2fe87ab1d8"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "b2705f9df372618d68948eebd3126534ddffcd4219382fc1ee92d603bcd14766"
    sha256 arm64_ventura:  "4304f93799a902c2dfc2cfb2f4d1b7dced855adadde6916be737bb116513b09c"
    sha256 arm64_monterey: "a6cd3a7058e93cd1774b20409f91d253774bf2ade0f6a13cb639e5d4f0ccc2ed"
    sha256 sonoma:         "d8a0db0a30cfb1c92623bae21bfda058518e79ada774002466d08ada08b26a88"
    sha256 ventura:        "b962b0506112e50cec9c6b306620c3ecee5d2149156570421faf86dda199ed96"
    sha256 monterey:       "dda3a043f3599e9f08cc4aa409b9990ceff2858b34f6c4a698f5ee394ced99f4"
    sha256 x86_64_linux:   "bde30862c63445b39eb5c3e642dd9bc9a532a19985bca0b4c878cba7d2059925"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"
  uses_from_macos "libffi", since: :catalina

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