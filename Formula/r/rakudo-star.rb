class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.09rakudo-star-2024.09.tar.gz"
  sha256 "5b320e963aae8c0345b3ecb9a3d7baaf377729d256548cdafb246076ce65555b"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sequoia: "8d4d27d6c4e1da20405a88d74c302bbda28ea700d5996c33061c4841ec5a1336"
    sha256 arm64_sonoma:  "d1e04b5127716e84faad88907739b4b2081407f5ed525b3e002b036b576569f9"
    sha256 arm64_ventura: "d226993246c904de425172b66ed2b71045fb4e6dd631326fe6c4c5a08c35184b"
    sha256 sonoma:        "417f2b123582a7ce54e7def29195441776a03b15143d6c1f6cb3aa10409ecc9d"
    sha256 ventura:       "e0895fac6d57975ebf477d53703afdb3d883f194d1fbf59089c90ceb666d1efd"
    sha256 x86_64_linux:  "2fdf4b5e6e059ba6f8945a33439c684db82f9c33b2c8a06ee3d64224a6950454"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
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