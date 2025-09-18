class Libsquish < Formula
  desc "Library for compressing images with the DXT standard"
  homepage "https://sourceforge.net/projects/libsquish/"
  url "https://downloads.sourceforge.net/project/libsquish/libsquish-1.15.tgz"
  sha256 "628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c15bdf4ca7dde73653792c819df794092170e884ca1e7aeb006810955c3db6eb"
    sha256 cellar: :any,                 arm64_sequoia:  "e8c9dcc536fed98d8b68dc6187b2ccbd47dd3fc08d4590811ca605c4ff6c6a39"
    sha256 cellar: :any,                 arm64_sonoma:   "0beb47e5cedce2bc7f35e15f7e5c87033abdf5e03967c9501b2ecb3c736aacb3"
    sha256 cellar: :any,                 arm64_ventura:  "7bd2ea5005e2f7df26fa4e2a4e3cfee9ed35632abc8df40134ec09b23a58a466"
    sha256 cellar: :any,                 arm64_monterey: "a63fe0fd24c9446e06649595928249487026ed7b2c3b48131bfe31bc0cae0d9e"
    sha256 cellar: :any,                 arm64_big_sur:  "7ef2623fe17562ebea99fd2ebed7e15d70e29a54071d3f573dee0880c206fb01"
    sha256 cellar: :any,                 sonoma:         "016119dad4873f71b06982f17b09b4cc7cf4f6f9ed142ca97cbcee98cd55ca2a"
    sha256 cellar: :any,                 ventura:        "81f54cd573ed8d41a76319d89d4a4576ac3ce1f2acb7749daed4df249dc4bf9d"
    sha256 cellar: :any,                 monterey:       "8ac755fd247f50e6c82c3463a33fcab97ca76d0ee5935ce2277820f93074a694"
    sha256 cellar: :any,                 big_sur:        "592d8697fad360a07cd1492666f93eaf4542cc78454d57a9748290ed634a91c0"
    sha256 cellar: :any,                 catalina:       "44cffe8e418149d4e95af569edbe291e8f9ac85acb3458ac2ca78a8fe89fcffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "63bb6480b01645c86ebb55dec9a855fe1f4510b3c9dbb4ca88a73b1dd767c9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e24859a5f1a100ae9c5bb157ca24ae3740d8ef2f3dc22cde3d138bd99e534c"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    args << "-DBUILD_SQUISH_WITH_SSE2=OFF" if Hardware::CPU.arm?
    # Static and shared libraries have to be built using separate calls to cmake.
    system "cmake", "-S", ".", "-B", "build_static", *std_cmake_args, *args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libsquish.a"

    args << "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "-S", ".", "-B", "build_shared", *std_cmake_args, *args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <stdio.h>
      #include <squish.h>
      int main(void) {
        printf("%d", GetStorageRequirements(640, 480, squish::kDxt1));
        return 0;
      }
    CPP
    system ENV.cxx, "-o", "test", "test.cc", "-L#{lib}", "-lsquish"
    assert_equal "153600", shell_output("./test")
  end
end