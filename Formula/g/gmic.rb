class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.4.1.tar.gz"
  sha256 "97c9fc976e2b59a16e0257a5190d9fc3d08b64b12774781cb14ed0327c48d94f"
  license "CECILL-2.1"
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eudownload.html"
    regex(Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.tim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70cde7adb66f7a85b0919f238d3610bd2c9d801b3c72f008828a9bca2c9110ba"
    sha256 cellar: :any,                 arm64_ventura:  "55b143a8d58522965eedb93721bb91b05a8ba8609e250eae9bf853ddf3b6c1fa"
    sha256 cellar: :any,                 arm64_monterey: "c269e3ca640aa464afcc966f1abdfc7ca0a88f8c5b5d31616011ff7bf8658b9c"
    sha256 cellar: :any,                 sonoma:         "b59374c3aa3edf48946786ebfcf91061c6d33beb356bc20deb52da245f273734"
    sha256 cellar: :any,                 ventura:        "c8747e5b854d0c66154aebfb85c6fd7f6b3c2e0bf0e1cefa6acd464571756e78"
    sha256 cellar: :any,                 monterey:       "c674999aaec9da7d0e8755552d5c064463e017a9a2c719e2b83c7d05f06fa037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b998b7547628995472ccd62d941474c9263e243928fb9b11576d639d16952a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
      system bin"gmic", test_fixtures(file)
    end
    system bin"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath"test_rodilius.jpg"
    assert_predicate testpath"test_rodilius.jpg", :exist?
  end
end