class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://ghproxy.com/https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.0/SDL2_image-2.8.0.tar.gz"
  sha256 "76ba035fd032c12987e4a0d39aa1f2e79989a51cea72f79d18ab084a24adc9cc"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    regex(/release[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb3ff9340a74b2a20c2189b133969c2d3850bf25a71745aca3af5c6b5714b340"
    sha256 cellar: :any,                 arm64_ventura:  "0025f479469cadba2f08254c251023c24b4ca6b2f31225d4a205cc16f73d29de"
    sha256 cellar: :any,                 arm64_monterey: "cc98711b0a669690e39a788ed6e06aac5f2d8093a8d2fb54036a6b8253c77f28"
    sha256 cellar: :any,                 sonoma:         "596d87e3a7a5da03728e4c49ded0e25056d23e812e09dd88755703fbcb0fa685"
    sha256 cellar: :any,                 ventura:        "ecacea75ab1b9141947a865144814d0b59ffe4d46ec8085c38c876fde5469495"
    sha256 cellar: :any,                 monterey:       "4b39704aa84728ba513aa38c9485af0b104db1287a9aabcf3b391092b0ad7fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cdf234c3670d08dcfa6f8b68800ed1f5a9510c83ab3587c39da950ffef51743"
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