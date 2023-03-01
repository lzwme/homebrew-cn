class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.84.1.tar.gz"
  sha256 "208305e9e6c214fb46ddd5be7205b29d65bf3dab2062d294d30c9b669b4f0157"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "339a85763e5d156ebd7213c03edc50098152222a02115525b462660d9e8d59d9"
    sha256 arm64_monterey: "74597ad0b1eb82500dd64c211c533892dcac7023f8e1337af284b5ff76c1265e"
    sha256 arm64_big_sur:  "55e69002961b8f4024f621c60ab0d8a957be97d48b8186298731010300be2273"
    sha256 ventura:        "ad6cfe811c11b01624d849a095c69f2dd570a160c8ca1eba4ee0c9ace01d83d0"
    sha256 monterey:       "1b352bf5e1328f37f336c4c8a93bf7c9da4516afdc263c10c3f3b6af6a8d7105"
    sha256 big_sur:        "49735451b6890c319fedc6798acd01ec60b7a7d13610c4fc6022271bc7c0c74b"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on :macos # FIXME: build fails on Linux.
  depends_on "ncurses"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    # The `configure` script hardcodes our `openssl@3`, but we can't use it due to `libevent`.
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@3}, Formula["openssl@1.1"].opt_prefix
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