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
    sha256 arm64_tahoe:   "4dfdf7a7f848a133a186204dd626a72df82392ec169e18fc9e56c3f6284e7f8a"
    sha256 arm64_sequoia: "47d8010ce0c8b2e3d20345b3e8157dbdff2f7d8762153eeb807f3f8f493913a3"
    sha256 arm64_sonoma:  "cfc71c56307e00a41c5b1cb503529c45588bf7a29f2b4bbe25d796aab99860bc"
    sha256 sonoma:        "32bf251bae26c97074b2b25646d5d6cf40041f45bff9a3d8dd0ef88fc12e3f55"
    sha256 arm64_linux:   "cc22145acd0c5629c0fb8724b5a9c09c8b9c399f4495911337c3ea51c594b245"
    sha256 x86_64_linux:  "966836a9ddb5586f03d189393497845bafc09b79510bee329e25d4471f3d4f1f"
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