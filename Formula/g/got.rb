class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.99.tar.gz"
  sha256 "aea408353a02b2e3ad9b4d1b7607900269af97986d40998c57f10acdf0fa1e38"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "538beef159fa1123e090cc249fd03bd2060aa8acfe2597692085e11159fab59b"
    sha256 arm64_ventura:  "8842a01c7156826c56ce6a5e169bed54c5572f5075ac616a2e75100f6dc6e4e2"
    sha256 arm64_monterey: "22acd338fe8f33d354933924599d001c28d3c9766da42a1e49579d2e2361fd37"
    sha256 sonoma:         "b26824243b742b45f7ed14ae787fb332a5f6691736a0620cef0bea51b1b7ce6a"
    sha256 ventura:        "bfd43d7bba44973235ee55700a4eb370b06d2725ac46742f53873e00c04da9a0"
    sha256 monterey:       "25c0303951418d8f39a2d39221c38cbe3910c99282a421876eeb91068cd679aa"
    sha256 x86_64_linux:   "39beb5bc3cb9d7f9849bd574cd04a5ce606fac49f4a54d4aecc09d6bd2031d0d"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libressl"
  depends_on "ncurses"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@\d+(\.\d+)?}, Formula["libressl"].opt_prefix
    system "./configure", "--disable-silent-rules",
                          "--with-libtls=#{Formula["libressl"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end