class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.89.tar.gz"
  sha256 "27404932c07713400124c15e318417385411b7a1fe7ee534e48f2b9e4f096d8c"
  license "ISC"
  revision 1

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "164c221a9c9fe3a24aef850f02eaa3f108e31e504d419efbf0616d5504e6d0bb"
    sha256 arm64_monterey: "7a6e4270f5e3bc5092b7316dc0af1c3081a478da2029d0769709e09b652d9bf2"
    sha256 arm64_big_sur:  "864a0222de83272b73021170d9ca6446a15186112a70be7adee76e458ba02db8"
    sha256 ventura:        "3436fce13006bd58cf3207cac58547a52ca8d1072b90ad6dc6aba472e4bc9c3c"
    sha256 monterey:       "fe5e2cadab469e8b06b3e1451b40885c4ff5d2f5756e66790c90afdd26e06ce6"
    sha256 big_sur:        "197d16bb8cfad3259ce49e1fb2ca2878534d5642da9140cc683cf5a45ee52129"
    sha256 x86_64_linux:   "312871354d9f37ecbdfc6ada6f290cc9496d3a850fcad984bb6e88b279d14f81"
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