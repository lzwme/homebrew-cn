class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.4.2.tar.gz"
  sha256 "9abd8377693715f87104bdbe077d45ecb00cf19f57c29f425eacda07c745fe8a"
  license "CECILL-2.1"
  revision 1
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eudownload.html"
    regex(Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.tim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f6aea0f8a903364aa0ce16c5b93e3ce5c8f1731032a7afce6bb47168fdb9173"
    sha256 cellar: :any,                 arm64_sonoma:  "02d1a9cfde9f30969677d3f80bf7aef5b347624f4614dfadacbe70b46a79a381"
    sha256 cellar: :any,                 arm64_ventura: "f756f70c63c0d7feecc96db001c33b3b508815470afd70772bac0b1827c48960"
    sha256 cellar: :any,                 sonoma:        "159958616267b4f92a1b73e1451a9b15925cb5a90695d6f91cf58516c9e3f732"
    sha256 cellar: :any,                 ventura:       "e852a229fe12e7370b5537cd355b3b06188f9ab1a400002bedab9b4b733ae3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c27705afeffa586eab9809e5fad8d8da3d63650b2d1043730e80e4a8b723b911"
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