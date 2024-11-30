class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.106.tar.gz"
  sha256 "3079d742c125047de339dd923d75d0b960995a3a4b567ed08ef36d112bdb07cc"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "aa675c0ba3c88df8a3f062a4e9fc66c1b0ee7a0328b081deaed8f2951d41621f"
    sha256 arm64_sonoma:  "2b6fadfaed7a22e4c9b3079ed8a7cbb6f144da58cf7bbd910f4ac06268dcb5f3"
    sha256 arm64_ventura: "456c9e5b37e87ca769f77e9f9070f46894ce28d61cc25c20a92dd2b8af99678f"
    sha256 sonoma:        "c3ae323a20bacccc9a156a385ffcba1f24a9af431d65a054a91a8042f2056d7c"
    sha256 ventura:       "49300d5bb4622fc423386b30b236ebb18253dff0bcaa15445412061c4e48e1da"
    sha256 x86_64_linux:  "be562593a5a65cee5de6b7cca1adc124fd93cc6dbce35517c3cf9ee1db2f2e51"
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