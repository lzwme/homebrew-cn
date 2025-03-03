class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https:github.comlibsdl-orgSDL_image"
  url "https:github.comlibsdl-orgSDL_imagereleasesdownloadrelease-2.8.6SDL2_image-2.8.6.tar.gz"
  sha256 "b71903ef444e6011b7d7751f2cf1bc90994810e199818f2706be62d45b10a848"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL_image.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "84f09de299de6c147ccbfd0d5258c27f7a4a7075d644a9fe72ffe8e7c7ef168e"
    sha256 cellar: :any,                 arm64_sonoma:  "9dcdf97793f42c2f013449a7640d853466af49cca7f5ba2e5d36f56638a33173"
    sha256 cellar: :any,                 arm64_ventura: "720eb383ff0a81410128e960513fdd3d27a520ed44ba2ebecfe607c1f575e738"
    sha256 cellar: :any,                 sonoma:        "e0c534f82cd0b5be59945daa7560b5a68dea1dba96a77c65ec238e57a324c093"
    sha256 cellar: :any,                 ventura:       "098a17cf7e7c06ac7ff7ad901ce4b6c17979cf05835774f403c430111878da12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24042d09ac43805f8d0834349c93a26ef72093044936aa5660fa24e8d9fbd433"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    # upstream bug report, https:github.comlibsdl-orgSDL_imageissues490
    system ".autogen.sh"
    system ".configure", "--disable-imageio",
                          "--disable-avif-shared",
                          "--disable-jpg-shared",
                          "--disable-jxl-shared",
                          "--disable-png-shared",
                          "--disable-stb-image",
                          "--disable-tif-shared",
                          "--disable-webp-shared",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <SDL2SDL_image.h>

      int main()
      {
          int INIT_FLAGS = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP | IMG_INIT_JXL | IMG_INIT_AVIF;
          int result = IMG_Init(INIT_FLAGS);
          IMG_Quit();
          return result == INIT_FLAGS ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system ".test"
  end
end