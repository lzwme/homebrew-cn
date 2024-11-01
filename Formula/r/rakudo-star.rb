class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.10rakudo-star-2024.10.tar.gz"
  sha256 "55e466112f3edd3600d58342dae8cf013ce7085804c3dbdb2933b7e6f5c4a19d"
  license "Artistic-2.0"
  revision 1

  bottle do
    sha256 arm64_sequoia: "b601cefd4a062973b3e6e73dbec71e340995a960ab988dc2a9e9dd3f6fa2631e"
    sha256 arm64_sonoma:  "fce2183bab91b8809271c5ead9988373b195603b77af8f5ffd606a2e2c5a3954"
    sha256 arm64_ventura: "9bdafbafc7a9cdee0a7442d5a4d77af189e6e60a3ee8e288b400d533726f97f4"
    sha256 sonoma:        "4207dbcba18f871514a1768128f47470559321bb0ad23a712f904bc70bd59900"
    sha256 ventura:       "b7ca634f1aa9d6e3870f19a2f032168a06d0822530c18456d230e126f6ad8386"
    sha256 x86_64_linux:  "30acce390cc9d5020833aa98ddc72d03657c76d26dfc0bb207c86a48a42296bb"
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