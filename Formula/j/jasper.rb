class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://ece.engr.uvic.ca/~frodo/jasper/"
  url "https://ghfast.top/https://github.com/jasper-software/jasper/releases/download/version-4.2.7/jasper-4.2.7.tar.gz"
  sha256 "e133ff3e3260069f2f77b65237c1bef680c20ebaf817d0e15106bffd8e6dea53"
  license "JasPer-2.0"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0822e2cad8c403644be6e314e5435f1ece269c2d5bad36405a04dcd5cf060e6c"
    sha256 cellar: :any,                 arm64_sonoma:  "7df52f8c3dfdca1ec7f0391e2864f82d92ca9edd7dce70c5f31ac91d9de9d190"
    sha256 cellar: :any,                 arm64_ventura: "1f63c87da03346948ad63635e9dd1ea140e64336c32e034a2d3deea3f0f00a5a"
    sha256 cellar: :any,                 sonoma:        "fd53160a0ddafa19cc2bf24c1a93794790508e1fabd1040acb93b418accb8c17"
    sha256 cellar: :any,                 ventura:       "c5813d7003e7bd4fd3e7922d8d78ded833182344d1608378d5ff8ee5629657ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b50016c97fd803fb27c3d65ed67a9eb451b89e71966103b4eaac9c92a45787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0829165d51427de47321915b969648966a3c42a41f83009074346950dca5a02"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"

  def install
    args = %w[
      -DJAS_ENABLE_DOC=OFF
      -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=OFF
    ]

    args << if OS.mac?
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      "-DGLUT_glut_LIBRARY=#{glut_lib}"
    else
      "-DJAS_ENABLE_OPENGL=OFF"
    end

    # Build in the parent of `buildpath` to avoid errors from upstream's in-source build detection.
    system "cmake", "-S", ".", "-B", "../build-shared", "-DJAS_ENABLE_SHARED=ON", *args, *std_cmake_args
    system "cmake", "--build", "../build-shared"
    system "cmake", "--install", "../build-shared"

    system "cmake", "-S", ".", "-B", "../build-static", "-DJAS_ENABLE_SHARED=OFF", *args, *std_cmake_args
    system "cmake", "--build", "../build-static"
    lib.install "../build-static/src/libjasper/libjasper.a"

    # Move the build directories into `buildpath` so Homebrew captures log files properly.
    buildpath.install ["../build-shared", "../build-static"]

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/jasper.pc", prefix, opt_prefix
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_path_exists testpath/"test.bmp"
  end
end