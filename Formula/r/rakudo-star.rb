class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://ghproxy.com/https://github.com/rakudo/star/releases/download/2023.10/rakudo-star-2023.10.tar.gz"
  sha256 "4c5fb2bd521ac2bcb9f747bb854fe1682dd64a6e69d3636e4101f6c6b5cdcd95"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "cd07f9be4d1ef449d10d0fa0400d34445ead526ebf63561176b0b0f212c8f6ac"
    sha256 arm64_ventura:  "bc202148ebd4833ba61943d03053a00ec6684e453ad57ae1c877710200c64164"
    sha256 arm64_monterey: "f5f1409fd6a4c4873f53cb64596fafcb8520dcaeecdf591ae67e2785055a7ed2"
    sha256 sonoma:         "fe94b6fa9e77c58acd9fafede5fd39b61bbbd17d5c454c4514a41cb07976c82f"
    sha256 ventura:        "3498255caa1e1ec8cefd9bcb0fab2cdf16ac5d0fe3b1ba3a10c83bd0d1c490d1"
    sha256 monterey:       "c3a8fd192571cb4d203dcd56dca19e919ec75122d8e8e2c29eacd1f06a5dcef8"
    sha256 x86_64_linux:   "6b478adc00ed2226d06ae836f5303623a932f7ad85c00ed237e0b3d35e6e5ef8"
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
    if MacOS.version < :catalina
      libffi = Formula["libffi"]
      ENV.remove "CPPFLAGS", "-I#{libffi.include}"
      ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"
    end

    ENV.deparallelize # An intermittent race condition causes random build failures.

    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"

    # openssl module's brew --prefix openssl probe fails so
    # set value here
    openssl_prefix = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_PREFIX"] = openssl_prefix.to_s

    system "bin/rstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in share/perl/{site|vendor}/bin, so we need to symlink it too.
    bin.install_symlink (share/"perl6/vendor/bin").children
    bin.install_symlink (share/"perl6/site/bin").children

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    share.install prefix/"man" if (prefix/"man").directory?
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end