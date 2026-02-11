class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.121.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.121.tar.gz"
  sha256 "d40ebeebd224080cda96111572e863e8a3bf2235c8a953a27e24511a8988209a"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6e045dbc306dce23715fe18adf273cf608c97b0d2c8b42ec0af8c290baa679e2"
    sha256 arm64_sequoia: "d9f9750836c7a8f7b2a2082ff76bd3ab986271002f11b948b2c06033655efee7"
    sha256 arm64_sonoma:  "9ae17930db89d78f99b106804a9873f756f70f232e0879b90bb35aafc5eb71e1"
    sha256 sonoma:        "66651d2e96370254b070d848d13656a560cc2ca8b3d06e7acb460877eed8c8c5"
    sha256 arm64_linux:   "533057457e59f06f7fa2f4dd823da42c9cdefc7444608d5e5ef2a7fd0cb6180a"
    sha256 x86_64_linux:  "fda480ff9c76f92f85f030c31289a9b9918500ff941fa102c345fdbd51c8d130"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@3"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
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