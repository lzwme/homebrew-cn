class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.0.tar.gz"
  sha256 "64c32e1a58e9d7de3f84220183bab06423bd9823afacee9a9c7b23768b8edc33"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbddea5f478aa1cc7f593c9cf4d08a122a39f1f1ce7f321cfd89116af084ce3b"
    sha256 cellar: :any,                 arm64_sonoma:  "6c1a4fd065487528d00aa926c937399f065dfbd832be40b761ac60768d7e89a4"
    sha256 cellar: :any,                 arm64_ventura: "99198cb92714cc0e5adbdf19369944623b894e20c603067e649cea46d2ed17c8"
    sha256 cellar: :any,                 sonoma:        "aea36a94054b77dd2abee1609bd140be3d19e0587ea2814d0618f34e277c34b2"
    sha256 cellar: :any,                 ventura:       "29dad6214b30b65b571a3b2e1e31a086c006d85c85251eddbd363df05c0256b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e56176d0173e86b44dfc6f84c86ba948195851b2c4c0e719542dfed36d88812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11f12de99385691a00900d1dd4812455328068783d6b3e35e78b56b9fbd01cb"
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