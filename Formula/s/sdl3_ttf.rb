class Sdl3Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https:github.comlibsdl-orgSDL_ttf"
  url "https:github.comlibsdl-orgSDL_ttfreleasesdownloadrelease-3.2.0SDL3_ttf-3.2.0.tar.gz"
  sha256 "9a741defb7c7d6dff658d402cb1cc46c1409a20df00949e1572eb9043102eb62"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL_ttf.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b21aac59ebbfa8d1d48a6b4af48d3d40bfca296969ac68c865a08b3658b7a55e"
    sha256 cellar: :any,                 arm64_sonoma:  "7091e1cf1509f9dd45f83e7e35e1c56b26a2d32e94de49a6ed736368987a2b5a"
    sha256 cellar: :any,                 arm64_ventura: "6b3fbbd588070465a0c7f7e4c6e9912a2fc205eae35a35110c33b95e9b4ff4fb"
    sha256 cellar: :any,                 sonoma:        "84e823f88b1f5065b9257c65957cf09c12767ceb76069463b0290c2e754b4b82"
    sha256 cellar: :any,                 ventura:       "aa23f7ed84eb8e6612b43e147eb3dd49ccaa7839637ace30b5ec587a5ee1a143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bcfd11ed3c7df9612ce4d4fee38e07c3b529826ce03dba8b4da199e0e84bb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e14391b5465568ff8b81a6600ea53734bea2899f3922b626fe05704b4b8dcc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl3"

  uses_from_macos "perl" => :build

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DSDLTTF_PLUTOSVG=OFF",
                    "-DSDLTTF_INSTALL_MAN=ON",
                    "-DSDLTTF_STRICT=ON",
                    "-DSDLTFF_VENDORED=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <SDL3_ttfSDL_ttf.h>
      #include <stdlib.h>

      int main() {
        return TTF_Version() == SDL_TTF_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_ttf", "-o", "test"
    system ".test"
  end
end