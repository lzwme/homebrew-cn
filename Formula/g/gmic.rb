class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.5.5.tar.gz"
  sha256 "f77999dbb6cd95e2766a0fa1c6ea3ec61007a981ff4644cba2cfba895ec1dff3"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "001e4f452226180218de22516e18607081d4ac4da25df5886b9923efde568afc"
    sha256 cellar: :any,                 arm64_sonoma:  "46e34d4527962cb6e35e9a06aed275412da4466a670bd8242a30236c2f338036"
    sha256 cellar: :any,                 arm64_ventura: "cd20d6aa0d6e342fa525d8c8f560a0471b0c571aa8118f64b5119488af6840f1"
    sha256 cellar: :any,                 sonoma:        "aebde9a806ba407a84b77391ca1d1f0ece79abb00a4da4e30c206564ce9129f3"
    sha256 cellar: :any,                 ventura:       "4cdcd1b245d3166c88893498a9e85dd7273ecb20c53da9e0cbef8c61a5aa3ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e35dbc1d8acf5551f088df61537ff318cb1759bc6594eaccfee69189d6e8fb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaac80c33e8ef5a3b0c53fa209b5a705fdc05234f21a082ce778203209f67ba3"
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