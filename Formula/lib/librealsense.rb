class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://ghfast.top/https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.56.5.tar.gz"
  sha256 "58b2029eb7179afc7ea893c25be38a65b42c5b6d27330c8c611bc0e0a4ac5a85"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d8da2e42edac2b69ae06d6ca9cba7c3e1d6071b5ec33395490d343f7fd5c07b"
    sha256 cellar: :any,                 arm64_sonoma:  "d4436faf0132705d1286b0e2519b362d08a622ee2a61dbe538325bce6a02bcff"
    sha256 cellar: :any,                 arm64_ventura: "032deb6a806bb92756046ac21e16122992caa449da969f16c40428133c3222d6"
    sha256 cellar: :any,                 sonoma:        "ad41dbd3e7e4b4a6320d9b4b6f596b125238d9f16c311e9c8192d0f947d92520"
    sha256 cellar: :any,                 ventura:       "5093d322e763658ce4b73189cb6413784f0a5e55f277e0432357d7a98a8ee125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b52b64e1096fb023d53337b0d03303e7b097626e220e253d01ff5af4a579784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f42c85472cc7b82627dd1d46a13465395d1862f782c264ffd262cdfc657986"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glfw"
  depends_on "libusb"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].prefix if OS.linux?

    args = %W[
      -DENABLE_CCACHE=OFF
      -DBUILD_WITH_OPENMP=OFF
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DCHECK_FOR_UPDATES=false" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end