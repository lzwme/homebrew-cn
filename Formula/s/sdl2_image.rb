class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https:github.comlibsdl-orgSDL_image"
  url "https:github.comlibsdl-orgSDL_imagereleasesdownloadrelease-2.8.3SDL2_image-2.8.3.tar.gz"
  sha256 "4b000f2c238ce380807ee0cb68a0ef005871691ece8646dbf4f425a582b1bb22"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL_image.git", branch: "main"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(release[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb95b0770931a48a9910421cd92f609e1d1c5523e26183b8950aeb8627695515"
    sha256 cellar: :any,                 arm64_sonoma:  "7a5a42dd08474c0365e30e6eda4e4709247c9f9d39ff5217017f2f2887fc40d2"
    sha256 cellar: :any,                 arm64_ventura: "5b60ade973f87281d28c65ed3a81ce2304a63d40ba4064c7ec06fab93b8f5bc4"
    sha256 cellar: :any,                 sonoma:        "6761072329bed214194fa2dd4636f39f499a4a5c8a7f243afafd97f087a7dac6"
    sha256 cellar: :any,                 ventura:       "b9aefd03a26f19360905939d5454e9d76ab4ffe6a80e3cce7ceaee63f9631f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9faea474543756600f7845868ab27241297734bbe1bb1565b7cf43de44fc8aa7"
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