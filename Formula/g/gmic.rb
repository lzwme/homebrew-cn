class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.5.tar.gz"
  sha256 "c6771c48693ed615b2e85d1db7a9626358d4606eb2c75dcf009b2924f396da59"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c23127101e92ce5c39b9ceda747069faa9a183de7928e8fcc1d4c3249cd62499"
    sha256 cellar: :any, arm64_tahoe:       "e1eb7aafdb2ef5553893b7d37b77465490dafd03bd654178c3ea0e81be1d439c"
    sha256 cellar: :any, arm64_sequoia:     "380e021c05d657ecdf4cbaebe8fd8ecee7812d8a6e6c85f3461264abff3f731b"
    sha256 cellar: :any, arm64_linux:       "a8f60f8fd9e18309cfd0e24455e33f4445b0af8ccd95b40ec68ea8779b575ec2"
    sha256 cellar: :any, x86_64_linux:      "27e2043a8e924509a09e54ac1c89f2188a6a98b8403f1815e95ee23771ef8e9e"
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
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    args << "-DENABLE_X=OFF" if OS.mac?

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