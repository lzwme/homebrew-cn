class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.117.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.117.tar.gz"
  sha256 "8d53ffd6f5f5749ba474753e47e45e8e53d57de541be8bb3b0ce8e8fc233c141"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_sequoia: "91281dfc2bf3fa399da88b785d5e9faae37edc1e1efc30ca608c718dab317d32"
    sha256 arm64_sonoma:  "272a2c8db89c1c9bcabd57a6d5aee6b9a45eb2cdcbf26288a7ecc64d9d85f12d"
    sha256 arm64_ventura: "7db02f186fec15d8b393a7b85a9b0b85f5396fe2610c84cb8c55fe0c4719539c"
    sha256 sonoma:        "6e32c3f264548c0944b08d52a4f9ca5e86a5a1348b229b145390d6a1497b4ca9"
    sha256 ventura:       "84b0084fb05edf39e5398b96119efe15eb58faaf65fab25b268aee462682d736"
    sha256 arm64_linux:   "002df23d9bbea210eb16047097eb661a378f3c2f954dddfc5cc4488b89ef90d6"
    sha256 x86_64_linux:  "029555008ccd027ec1e655bbaad86b81f5a8ecc13e9bc41e451601656bf07569"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    ENV["LIBTLS_CFLAGS"] = "-I#{Formula["libretls"].opt_include}"
    ENV["LIBTLS_LIBS"] = "-L#{Formula["libretls"].opt_lib} -ltls"
    system "./configure", "--disable-silent-rules", *std_configure_args
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