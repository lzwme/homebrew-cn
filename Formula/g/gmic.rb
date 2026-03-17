class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.3.tar.gz"
  sha256 "64d5e46077fc203d3e617076ae580f6699da16d7ee2ac63e5bbce0026c4350ba"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59968d037e996bc63eba28131d443647b3ca15a71e472c751f89edec44679a9c"
    sha256 cellar: :any,                 arm64_sequoia: "c9ed536f0532d153286c5db9908ae385576fff3aa3c3c778698d848467268dde"
    sha256 cellar: :any,                 arm64_sonoma:  "edd37645ac2bd5795ee93decde4a5b7da055f7e328f41f76402d24b627f6ed2d"
    sha256 cellar: :any,                 sonoma:        "45ea098fe4b4ff0e096a8b73292afabaed236c4fdadb9316c593ccf136ffb372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a370c665674fec46fd3348d924c46c407a8831ba199cb43d1248aec322907d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae66de68f16c63ff1f04c48ecf9f23fb7a20ff6bb0b7128ec5f65aa95e7fa7cf"
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