class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.109.tar.gz"
  sha256 "22d2dd54e15bc63fa0e55b289b4d587a43db33672414213c2ef718c5332c6a81"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "77f6fd1aeb61eb78b4de7248bd401034316db1d6824faa0ec983b01fd6749f7f"
    sha256 arm64_sonoma:  "59ff98e5deb2562b153c8abf3a0f112bc09e645588bfcdb3a10cb448c00fc5d8"
    sha256 arm64_ventura: "8b2fdefa811cd339365e682681ce7b3d66f2a75e4e8a0be7ee52bb749c5a5ebe"
    sha256 sonoma:        "5702ddc87e6a05505358e82d658cffc1e21f5d79b394336d76a1d84798de0fda"
    sha256 ventura:       "64101d4f757ccca917976887bd4a502a629ab190216c5b5f7d750c2eac43f297"
    sha256 x86_64_linux:  "b1b25611d17af76ded04cfc4ad0a56530b60a6497cefead881ea979915f650fd"
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