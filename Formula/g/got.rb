class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.101.tar.gz"
  sha256 "25064182c731a0cbf80e48bbeecf2d628e2be41046f84aec0d89d8e7f6a6dcc0"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "ca90b719e44fd037ca635068987c9a166d009ee6f504a6eb29d8f6f58c552e11"
    sha256 arm64_ventura:  "88901a3c58056bc87b9ced054ff8e74dde8929fa4316f21d3a15146acb35ce86"
    sha256 arm64_monterey: "eed6bb0a29304c2f9ef670551621bd717b701f37183d327cdfa1d9601bf677c9"
    sha256 sonoma:         "3f6128f61dd171f95cac85fd97b62723b83f9490c0ab9ae45c09a53a9241bc48"
    sha256 ventura:        "560411ba1228e5cab0e5fd051d3712d53efc74f46c1e3fd9ab62d0a9c068ea18"
    sha256 monterey:       "cb985ae235fe3987bd9744890d74a52287a9927c11d13d54ca23aa245df01972"
    sha256 x86_64_linux:   "048f42d66b9ab92f3893968819175e5a96ca99185b7e693ecda0b25dbe7bc17e"
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