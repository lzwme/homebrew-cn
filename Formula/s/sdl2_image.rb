class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://ghproxy.com/https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.3/SDL2_image-2.6.3.tar.gz"
  sha256 "931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c"
  license "Zlib"
  revision 2

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f14ff0269c000e2b8652c49f8d2835f48648e54483d126b562206e14a51aef8"
    sha256 cellar: :any,                 arm64_monterey: "e0989678c782e57f0f4647f66e5e05ed32726d4e4c6ef9d94184dc6dd8e5373c"
    sha256 cellar: :any,                 arm64_big_sur:  "296fde5a7497eb99132ad84c7516c34915265386c093a95d0d972965d308b4aa"
    sha256 cellar: :any,                 ventura:        "31d279a5850274f05e554a431c7bced83f7ca2a630e850f6644a4dd215069581"
    sha256 cellar: :any,                 monterey:       "8106006bc5909a02088cbb369958827e12e7cad2a812b620692f1803560c021d"
    sha256 cellar: :any,                 big_sur:        "f4b1c030ae565fcf14b5bd63f98c629f6d7b9b8a0f332b48a08acf43d9efebfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e9cebf9e4ecc9f1c4fd55fa99babb47d586f33e24127f95adf0e4e7883f954"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args,
                          "--disable-imageio",
                          "--disable-avif-shared",
                          "--disable-jpg-shared",
                          "--disable-jxl-shared",
                          "--disable-png-shared",
                          "--disable-stb-image",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_image.h>

      int main()
      {
          int INIT_FLAGS = IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP | IMG_INIT_JXL | IMG_INIT_AVIF;
          int result = IMG_Init(INIT_FLAGS);
          IMG_Quit();
          return result == INIT_FLAGS ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end