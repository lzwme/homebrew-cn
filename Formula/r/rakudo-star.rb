class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.08rakudo-star-2024.08.tar.gz"
  sha256 "6af32e42753265843deda3a82a2f5b655318e95c030eb30af94670df4184e17e"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sequoia:  "bcda67793f3b23f58a794dfeb005cdd6cfb971ad2fe3a0321e63cd2c79b46308"
    sha256 arm64_sonoma:   "80a701826b5ab00507692f9e9cb825df32e2db079dd8545250034530b38cf80f"
    sha256 arm64_ventura:  "0287d3b494fe20cff5da89a8e8a1f41add2791989d6651a01e2b63ae0958f2bc"
    sha256 arm64_monterey: "e86bf57d8e5e521dfb63fca8c8b8c52628e2e30cb86068d9fa72586635a040a5"
    sha256 sonoma:         "bea9c7399f351b8dd305fcb1ff5fa8478fcb57d15761d40b66bed640f02f2996"
    sha256 ventura:        "48d57ac5fff76d79e8f52a8610e328ec1e006306b20a1ae660225a0d160755e9"
    sha256 monterey:       "0168ef492b64eefa0f4ac2e0b7c7bdeecaf057d886f597fa19fcc9765020ef69"
    sha256 x86_64_linux:   "9aa6585243214498db4198f4d71d72c3878ab4204b6dacf195f47ff717f3c8f1"
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