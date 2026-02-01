class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://ghfast.top/https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "134a24aeb84988c36d188d6cabb62521b5186ae09d7f26a0bb807a1bab51439b"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e763295b32c273fd05ded1618bf977343fc15186500326d8e1278300480191a2"
    sha256 cellar: :any,                 arm64_sequoia: "e04aaa5efa75b52684ab6e2841e2199f8373d36e3f95a21522ed992d097a6ea7"
    sha256 cellar: :any,                 arm64_sonoma:  "f9f000f924ff0098ae8bbda74980954084bc07907cbcd595a1c4894a50a83aef"
    sha256 cellar: :any,                 sonoma:        "9cd75582908d0d8dac9f97efbd575b1ce5c23a3ce7055479df4085b158d3eb17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a134a84224c3f5e4c3619cd9aa120f7f7a2cf41a13febeab788d99c994396879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6887c38b3786a6b7a496eedfdda930bc0bfdaca7c77bf1b642f0e2ec60db9a32"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -Dengines=sw
      -Dloaders=all
      -Dsavers=all
      -Dbindings=capi
      -Dthreads=true
      -Dlog=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkgconf --modversion thorvg-1")

    (testpath/"test.cpp").write <<~CPP
      #include <thorvg.h>

      using namespace tvg;

      int main()
      {
          Initializer::init(1);
          Initializer::term();
          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/thorvg-1", "-L#{lib}", "-lthorvg-1"
    system "./test"
  end
end