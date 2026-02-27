class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.2.tar.gz"
  sha256 "4b7018cc4dc88bbb933564f2c0dc31d3090989c4a7f6eee2a490f98b2861b32f"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c30b0b63460ad1da13b3c6ae8e4477f0075cf51b6d9de656b95e8805726f4efc"
    sha256 cellar: :any,                 arm64_sequoia: "ff3d7f54e7d420417dee7c691781837d6bb54c56ea15fb0ba7ba9f9688e93a97"
    sha256 cellar: :any,                 arm64_sonoma:  "2d78368f9bb6f36f3047865f6f68dc79215e41973ef40bcfff34dfd99060e31e"
    sha256 cellar: :any,                 sonoma:        "8fc44fd5c57416f7269e4702feff5eb3a4adae59ac4806820f414cfbaa1cb81d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03dc51983cd04a49d8b23c31b050841b1f5c0c3662e8479e99fe08142f90de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61cf6c9360f007f1533bd549de2507055d33740412dc81750b37d1f15dfb44df"
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

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libx11"
    depends_on "zlib-ng-compat"
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