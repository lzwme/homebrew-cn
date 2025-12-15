class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://ghfast.top/https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 9

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "d9713a3a4b39a4cdaf1fef081904e8509e9114a4d3b3930509f01e3ce636a845"
    sha256 arm64_sequoia: "9fc65bdc67d5f6f8f7caa44df2e8a224d7e40497736125aa06599105c9ba90c4"
    sha256 arm64_sonoma:  "2d7743f16c6829c28c5f2314e63297a2e437507efbd8404d24adb4f9a8086a18"
    sha256 sonoma:        "9251546a0fb2f6588862dc7a5f5850b8c15cd7077fcf59f2ef4375ba4f121edc"
    sha256 arm64_linux:   "71deac6511637ee0e267088d830135d4943a2fe7aab89a8bb5bc8c6d4f3116bf"
    sha256 x86_64_linux:  "ddcb8819bf67f9efdf3602f7576d9e3fbc3605c973ccea1102986ec524d000e1"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11 # to build with boost>=1.85

    # Workaround for Boost 1.89.0 as upstream commit requires regenerating configure
    # https://github.com/acaudwell/Logstalgia/commit/823a1a4dbdba8f682e2d31851c11e369e50aa0f7
    if build.stable?
      odie "Remove workaround for Boost 1.89.0" if version > "1.1.4"
      ENV["with_boost_system"] = "no"
    end

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end