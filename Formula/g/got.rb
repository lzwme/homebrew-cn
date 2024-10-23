class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.104.tar.gz"
  sha256 "b32d787920bc497521395a06beb07d7f4f92b693795863224b6049d3d669c8c9"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "7818e57f951bdd67cd26a4b21c7a22ba0edfa492a69263e456dfb5fe05660970"
    sha256 arm64_sonoma:  "dc2ec80cb143e0909bb35b8bfbb3c8792b43dbb36bad841425843ce9270039fa"
    sha256 arm64_ventura: "b39177c3e8ece5df54dd6d0bf43bcb2fc9af0bbf534b878d1585da4a3e4cb16d"
    sha256 sonoma:        "8c7c0ace814d901b696cb03f491b5e3370fb73e8e07b4c8b8cbd5bc89566d9a8"
    sha256 ventura:       "b076d16a85ec85fd5313faa58c0c78e10260bcd7bbdbafdf025b875b01792eb2"
    sha256 x86_64_linux:  "6301ef138d880df53e9f559e37bf6b525dd51b8e88e0d5cbb599f2ca8ef05e41"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
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