class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://ghproxy.com/https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.1/SDL2_image-2.8.1.tar.gz"
  sha256 "e4cab9a58c347a490c46723c17553b4e12233cd821d3b993a8475a50497f5a3e"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6b286fd2880051a39458f237cc27ec1fbe1a48a69d6ddf577df139cdb28532e"
    sha256 cellar: :any,                 arm64_ventura:  "3e759917b601d71ca8ca34f1d4d7b3ee346e431a0345c8ad0bfa4c6fd15834ad"
    sha256 cellar: :any,                 arm64_monterey: "a76147a67ebbdec61fb1a398c912b29bf3eafed1eae788d34ff482a7ce3cd38c"
    sha256 cellar: :any,                 sonoma:         "ea2fcd78002d5b6fc6d40ab010fa3c22d3bae454673e1a6a2f6e1bd97253a5c2"
    sha256 cellar: :any,                 ventura:        "f20639001f4d9fa905d55453e0ab34d541c170ee0a310ed258e27c234f86075a"
    sha256 cellar: :any,                 monterey:       "83d8d6850f0dbb0fe6473884ee0da09ce190372ceb1e82ca1284872b0e5567a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f23736844b1ba583b4e814219abe129dd38ec2523020e85c5faf70485224e492"
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