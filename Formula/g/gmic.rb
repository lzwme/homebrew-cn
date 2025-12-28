class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.5.tar.gz"
  sha256 "0987e54d64dc3a82df6a3052e6aa5d5b5f1e9115c6fd4155e1aceb78e462169a"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "daa84d25a47208a259037fb353e6ae39f021cc1f73642e27ac99f6d4a85e9372"
    sha256 cellar: :any,                 arm64_sequoia: "b90605c4856646dd8a56942d8cb4244bcb04701d8c077e8e2f870a2a281adfbb"
    sha256 cellar: :any,                 arm64_sonoma:  "8f790236680e4995753690d026b2213fcd9811fcf579d8289a41b57504208805"
    sha256 cellar: :any,                 sonoma:        "09eb2d0798d1f7c276e0a3368713f88c2e1cd45e3e4fe57ef2ef9b7afe2c0e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fec1e1d0933ecc1467e6789d83bb26464ecb80dd1f60d3b07f82103e74e7a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8216c0ad7e3d5d26e1114f45047533c50ee7bea5f5cf6d55e5194b43b52e62e9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cimg"
  depends_on "fftw"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
  end

  def install
    rm "src/CImg.h" if build.stable?

    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    if OS.mac?
      args << "-DENABLE_X=OFF"
      inreplace "CMakeLists.txt", "COMMAND LD_LIBRARY_PATH", "COMMAND DYLD_LIBRARY_PATH"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_path_exists testpath/"test_rodilius.jpg"
  end
end