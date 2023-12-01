class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.94.tar.gz"
  sha256 "846d3f6beb24eae642c51f74f187d9096e38ab1fd2230c063bd9946b1c476779"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "486353940a182886fb38b49e8f04a971dba8010eeb254b2f24174ae8eeb41d4c"
    sha256 arm64_ventura:  "88d05f4ec22fb0310f326d1aef437ea71046122c0e51ad156395e74b9523d167"
    sha256 arm64_monterey: "44f99b2af0a469fa2136ebbfe84c2ba7ae6ba20b7947bae922fdb3c9c44ecbe0"
    sha256 sonoma:         "3bf350c3feac7dc8ba9a5eb172bddb636507a330802bf430b6694f1cd16e4541"
    sha256 ventura:        "279d0aa2bbbe106ffa8416470a8afc24f846bebee37e2b408efd95d286036042"
    sha256 monterey:       "ced8ce4d714b22994d9e5da3b98e2057bde39d5772c2883e06b82b92c77ecced"
    sha256 x86_64_linux:   "33ce0e87551c3262022851f3abe9605e1aebc5b49b725e694af7ee48eb4c5ee6"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@\d+(\.\d+)?}, Formula["openssl@3"].opt_prefix
    system "./configure", *std_configure_args, "--disable-silent-rules"
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