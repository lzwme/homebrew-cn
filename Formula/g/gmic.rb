class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.3.6.tar.gz"
  sha256 "783db018dece6dc443349ddf1cc85ff06b2aeb9a4612f795859c39c85d38fddf"
  license "CECILL-2.1"
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eudownload.html"
    regex(Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.tim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc9570a59e7f1da952c0e2462ade936c53d37bc7eeafa8dfd24484fd62d5973a"
    sha256 cellar: :any,                 arm64_ventura:  "2de30fd027cc5259b3a7715190362c7242f8b2a351164efe16154588d202d418"
    sha256 cellar: :any,                 arm64_monterey: "e7874607857384f572ceb96c31cd88b055d3203dd033a663371963f62dd8c689"
    sha256 cellar: :any,                 sonoma:         "e0934d639d85e5afbf6eb39ed01aa4bacdddd3a038a98dde203ffd9a3df622dd"
    sha256 cellar: :any,                 ventura:        "d5fce309d3f780779c2d88137ab550a13c563e1b92a37f5900f643ee87b4d483"
    sha256 cellar: :any,                 monterey:       "b8bb90b5aa90e1897f39a385c3535bd129157e31bc039ebd94bc7f53bf1a9ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c17e417f9ca175243984e464bb49b0e01a5a02ea7aa150d9120a096b28ed69"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cimg"
  depends_on "fftw"
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