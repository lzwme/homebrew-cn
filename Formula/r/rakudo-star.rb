class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://ghproxy.com/https://github.com/rakudo/star/releases/download/2023.11/rakudo-star-2023.11.tar.gz"
  sha256 "336f7d29f002d2511215b36d6afef31378874ce794e7ea774651f553179219f5"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sonoma:   "932aacf2e6bf1bf1b3ce76a68a495d54d7e35e311386c69ced7ce73cfb9947fe"
    sha256 arm64_ventura:  "7074ebc45efcafa5125815707004ffcfc2339fcc75f92e5285d69a26b80e2af8"
    sha256 arm64_monterey: "fe264d8e449feadf851c7d29d250a0437ee9a9ee4ab9b90da0f2eefd6b79a95f"
    sha256 sonoma:         "822616f005b8f33ac16cbfbb305e533fa27063e8db2d24d5ec9d5413492b1758"
    sha256 ventura:        "6ed4c9cdaf9f2e7d08feb3fc4185ddc7cd5f50915ae212988718892a4b2202a9"
    sha256 monterey:       "c6e4e22474191685aedfb195fcf6f25278c53d30a4773e8e21ded0f3066cd4d5"
    sha256 x86_64_linux:   "32e6c4cad20309ea434b22213f1664f3e6ff1c49cb2971fc6c4fcab5e306b704"
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