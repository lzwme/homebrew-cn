class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.03rakudo-star-2024.03.tar.gz"
  sha256 "b24cec9755b0361a79c7d8ac55c9a4e3ab71c46786c041e051798485f38d366f"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "fee27613066d91262c2ec042f5e992e80d66993b96c6a022b2168ee64e6eea27"
    sha256 arm64_ventura:  "9a4fb49f9df7da4369cbb0bc01d968e65c0a4b63194084f0663b8bec503efebb"
    sha256 arm64_monterey: "8c5c07b5d75452fdb54104722bce7516f85254d4fbf9aeed23684a2778a7b12e"
    sha256 sonoma:         "8c29fb0979e5caea99be238c15917a3c1a0b5043d274930a6166f86f01dbf74b"
    sha256 ventura:        "485a58fbb19dc39543fde77f30a7576ccbe294e093b6c951edf9603e5b40e454"
    sha256 monterey:       "ad6719a21f62274b0b29327aece74b05b890e702b48585e706dd94b3d55884c2"
    sha256 x86_64_linux:   "78a17db645723f3d123068c6e8141badb65d3eff70fee1095923656bc3e46198"
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