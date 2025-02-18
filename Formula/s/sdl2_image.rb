class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https:github.comlibsdl-orgSDL_image"
  url "https:github.comlibsdl-orgSDL_imagereleasesdownloadrelease-2.8.5SDL2_image-2.8.5.tar.gz"
  sha256 "8bc4c57f41e2c0db7f9b749b253ef6cecdc6f0b689ecbe36ee97b50115fff645"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL_image.git", branch: "main"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(release[._-]v?(2(?:\.\d+)+)i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5ceac706b224ec99a5ef598e701e21458efd60bd696c1642e46d3d56787c859"
    sha256 cellar: :any,                 arm64_sonoma:  "08d3d113697aa17bf1cff0ac358e8ab450c9be5eac7f3e18191ddaa687162a9e"
    sha256 cellar: :any,                 arm64_ventura: "8dfeccc064ee7c4686b1b8533d619d9dfda6d7e255dd8cc167f4b3e0bafbb8c0"
    sha256 cellar: :any,                 sonoma:        "7effd1e763e59b88d81784405a3064709492efea38f1d9775433ae41384e02f9"
    sha256 cellar: :any,                 ventura:       "4a8eec5331da79a54fd4359ddc4ab88adbf0137e29c56fb190afaa3674302140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c652e1fd5466f05cc18fbb460398246282475fc77e987421487478318f8f9e"
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