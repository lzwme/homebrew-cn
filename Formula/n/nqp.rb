class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https:github.comRakunqp"
  url "https:github.comRakunqpreleasesdownload2024.10nqp-2024.10.tar.gz"
  sha256 "1fd1ea24af91fa64f72880af8351de5970c3499dc89699a435572eee0cf5f482"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "c8173321d7a40d193ec214a30f00a2c002952ee9145886c2660aca46d7e81d76"
    sha256 arm64_sonoma:  "306175337fc49ea3b15a140e03e2e998b2ec69ef841fa43131899aa7f6200184"
    sha256 arm64_ventura: "2eb88b821ffdf875db940dde3cdfdc435088e9fd09bba63854f83b40be423c41"
    sha256 sonoma:        "7ac14dfd697753aee2b00f350f0f8aed700c57379e9cc6efaf4f34fdd1ba8563"
    sha256 ventura:       "fb2e6bd3ae32298f17bdf81c7a99698f3b2c19ab53ecb178b73963c9bcf6e8d7"
    sha256 x86_64_linux:  "0fbdf1a0d2df638c3f2247c26ad686db50ba67ad00c5ae146da89b800ceadec3"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "toolsbuildgen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}nqplibMAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end