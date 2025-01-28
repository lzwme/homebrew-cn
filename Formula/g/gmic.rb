class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https:gmic.eu"
  url "https:gmic.eufilessourcegmic_3.5.1.tar.gz"
  sha256 "6519408a258fcbab1916b479227a030fbb875280d1cfd0833d1391526fe51a95"
  license "CECILL-2.1"
  head "https:github.comGreycLabgmic.git", branch: "master"

  livecheck do
    url "https:gmic.eudownload.html"
    regex(Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.tim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "994e6f4cebcab9ce7b999b25e9f7bb1b529b66725f3407714bce57bdfe1f8ec8"
    sha256 cellar: :any,                 arm64_sonoma:  "aa925bddf7597c76c8eadc7e7c7e1635b84b082932c29f222ae2d63059afb11b"
    sha256 cellar: :any,                 arm64_ventura: "0703b26cd6e3ec95e863178117249b158242065417d9c13d4d830ed7948f11b2"
    sha256 cellar: :any,                 sonoma:        "11d96b77a0e84983b7df4ee978282a50310b190017d9c5e938890083c425eaa0"
    sha256 cellar: :any,                 ventura:       "83df8434acfc5954f354367412054f6802e1648add637d69fefffc66cf2f76b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b334254731333e1cc1513b100eae9bbf55cf70f84f6c18433101b927a88a256"
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
      system bin"gmic", test_fixtures(file)
    end
    system bin"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath"test_rodilius.jpg"
    assert_path_exists testpath"test_rodilius.jpg"
  end
end