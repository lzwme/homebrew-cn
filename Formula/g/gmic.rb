class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.1.tar.gz"
  sha256 "127a5e4a82d61958b6d2ffadbde57c68baff2b45886c2946ebd462a62306f7e1"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2ae401a25300e8b47db2c1ee1804cc8c29da43122c65ab613dcc9780f4c2a32"
    sha256 cellar: :any, arm64_sequoia: "b2814917d9287c2cacf6e9b43ccb75f7ea75b85a5182a00131f52f6ae87840d8"
    sha256 cellar: :any, arm64_sonoma:  "03b7450968cb327575bc883a49b75faa3c810b2ae3f3b520e51555de11e50857"
    sha256 cellar: :any, sonoma:        "351df7de95a1d0e31ae8f713be83f28de325604d392b99cf12947d08a1e03292"
    sha256 cellar: :any, arm64_linux:   "1df542a149069e61d015b8b560a26fd4d248217a0e06f10b3a23c2016ab5a88e"
    sha256 cellar: :any, x86_64_linux:  "057ff5bf793b0c5ab52f2dbdbe2b2680309efff262f879c1b6673b8765ba908e"
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