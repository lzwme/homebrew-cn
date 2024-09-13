class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.4.2.tar.gz"
  sha256 "9abd8377693715f87104bdbe077d45ecb00cf19f57c29f425eacda07c745fe8a"
  license "CECILL-2.1"
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eudownload.html"
    regex(Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.tim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "744ffa706d2f8d2a0a537b89a04ae07a62a1abd40b641608be5280a2549bc007"
    sha256 cellar: :any,                 arm64_sonoma:   "8b21e5f73a66d2d0858a10059528fb513a391ef521abc8c02126f557ad26c1cf"
    sha256 cellar: :any,                 arm64_ventura:  "5e2ac62336afbb6e9ece59aa80ddddeb4f39b10a3e251e4e8e8dbb599db1bdea"
    sha256 cellar: :any,                 arm64_monterey: "e381a0959ffeef741995b364675454662a051767c700d446db7705a5343da843"
    sha256 cellar: :any,                 sonoma:         "6830114554844fd69e9b827c4e64b0562d67fbb7ed38744063df4e15e492158e"
    sha256 cellar: :any,                 ventura:        "a7d6989a592b7ed15094739c560a4217d8e73a324f2950f52035988066b16dc8"
    sha256 cellar: :any,                 monterey:       "80cc2df53b946fcce8b149fa5db57801ed33fb9f7ed85c0b3c8652cb5249c548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76eec063601965ff78985ab1ce29d9f532829b5b159d6d7fc74d6a2a94936be3"
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