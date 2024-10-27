class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https:rakudo.org"
  url "https:github.comrakudostarreleasesdownload2024.10rakudo-star-2024.10.tar.gz"
  sha256 "55e466112f3edd3600d58342dae8cf013ce7085804c3dbdb2933b7e6f5c4a19d"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_sequoia: "46164a9b76f3b84b93c628b7ba36e36fda7ae2e832c9339deaf95561c3f4bd22"
    sha256 arm64_sonoma:  "2f8845d0dc5d96f7cb0a426d3ce0d75a5c08200a018f55484fea5093be15d93a"
    sha256 arm64_ventura: "c98291a0c681ff4b55a3e5254b4be43c92cf810dc2717e90d49ec7817909fec1"
    sha256 sonoma:        "558406b59fd4389b2dc914a946b88b94bc95a5ed1318275b35a1aac490877356"
    sha256 ventura:       "7509f9440968b1616d3f73dadfd7a71ba6dc0f3278704acb73919a3006fda5af"
    sha256 x86_64_linux:  "79ca9c8c03216f4eb5ee0d6d76cd4bbc78049d7947a58f5c32b14e9e53405c68"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c@75"
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