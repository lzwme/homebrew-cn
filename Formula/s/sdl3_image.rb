class Sdl3Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https:github.comlibsdl-orgSDL_image"
  url "https:github.comlibsdl-orgSDL_imagereleasesdownloadrelease-3.2.2SDL3_image-3.2.2.tar.gz"
  sha256 "fc6669329eb9f5ae644ca6ffa8ce0ee8749ab51c197b51476991df7407d8cf24"
  license "Zlib"
  head "https:github.comlibsdl-orgSDL_image.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "453aee27b49161b98c7befafe8606244f7298ea4655092fcd767310d7b302c09"
    sha256 cellar: :any,                 arm64_sonoma:  "090ac7e69870590e675a691c92f09ad8554eb3f8497eb7ab2e6e718569e0a0e7"
    sha256 cellar: :any,                 arm64_ventura: "f5e92e62cc4f37634047dccdd417c2bb4ee9e248cdcab711a7b91132661e407c"
    sha256 cellar: :any,                 sonoma:        "1ca40866631b8e4462e69545c19d8c4cf2f6b32828e04a728d03645cf623bf8a"
    sha256 cellar: :any,                 ventura:       "bceb89f44e523ac5d13c56873df53e55e80775d71dbd6cf1ba98277533c0af57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e509adb16a39e7d7658f81b3fb96cf23da105a1d625a199dcecfe0228e0ad1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl3"
  depends_on "webp"

  uses_from_macos "perl" => :build

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DSDLIMAGE_BACKEND_IMAGEIO=OFF",
                    "-DSDLIMAGE_BACKEND_STB=OFF",
                    "-DSDLIMAGE_DEPS_SHARED=OFF",
                    "-DSDLIMAGE_INSTALL_MAN=ON",
                    "-DSDLIMAGE_JXL=ON",
                    "-DSDLIMAGE_STRICT=ON",
                    "-DSDLIMAGE_SAMPLES=OFF",
                    "-DSDLIMAGE_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <SDL3_imageSDL_image.h>
      #include <stdlib.h>

      int main() {
        return IMG_Version() == SDL_IMAGE_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_image", "-o", "test"
    system ".test"
  end
end