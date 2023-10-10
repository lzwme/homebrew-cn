class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://ghproxy.com/https://github.com/lipnitsk/libcue/archive/v2.2.1.tar.gz"
  sha256 "f27bc3ebb2e892cd9d32a7bee6d84576a60f955f29f748b9b487b173712f1200"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "868ba8446a3493286376015ff0cc7d5c166ec0b0a59d2fe59cb1065cca68e226"
    sha256 cellar: :any,                 arm64_ventura:  "3f329f590af23cbb8af33de3e051bebbaf703322031973d08eb77e46a8eabaa7"
    sha256 cellar: :any,                 arm64_monterey: "58264dcfec95c078e190e8666f53f53b1ae01eaf30af3a8465857762654e61f6"
    sha256 cellar: :any,                 sonoma:         "01ebd6601efdde87ec1b188700ac15118850775da674a6922b8c6c87a00077e6"
    sha256 cellar: :any,                 ventura:        "79f01b6683dcc285f154d29a8ea2cfdf7544158f0e34f03e09fed9d9b034183d"
    sha256 cellar: :any,                 monterey:       "eb9cf37d8e694b11833cc4537e6f28f6a2710004e15fa7387f90bd46e6b09ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2970c8c8aacee0ff5025aeb3f55186658258881e334f7d9ee8f1d2d7c4f382"
  end

  depends_on "cmake" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Fix CVE-2023-43641. Patch merged upstream, remove on next release.
  patch do
    url "https://github.com/lipnitsk/libcue/commit/fdf72c8bded8d24cfa0608b8e97f2eed210a920e.patch?full_index=1"
    sha256 "93ada0f25cd890daaee4211b0935b875d92a52bc4b419dcb4bff5aec24a28caa"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
    (pkgshare/"tests").install Dir["t/*"]
  end

  test do
    cp_r (pkgshare/"tests").children, testpath
    Dir["*.c"].each do |f|
      system ENV.cc, f, "-o", "test", "-L#{lib}", "-lcue", "-I#{include}"
      system "./test"
      rm "test"
    end
  end
end