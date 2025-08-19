class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://ghfast.top/https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.57.2.tar.gz"
  sha256 "89a6b775a541355de2e951b5ff17ef5f0c8c9bcfdacbeb9e21478976c3357f58"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08618786b556e9f1b42823e2abeb171bfd9a396ba94480ac36e0a682f8e92ca1"
    sha256 cellar: :any,                 arm64_sonoma:  "c8308fcb0e42763606ef3185f13837334f2633ce9d8108b8b054e17474fad5cd"
    sha256 cellar: :any,                 arm64_ventura: "f81aa77393ab0c05705dd381cf620082533d47b5eba9498fbca8f3c9cdb4a89c"
    sha256 cellar: :any,                 sonoma:        "ec196f18758a363f9dab5943eae76aa321cb88f1e4399afbf896c337ddcc3351"
    sha256 cellar: :any,                 ventura:       "1bffd0682cf8ef3d0bba40857a1013dc62aa419fa5820af661e5935368f0f833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "953817cb85c015eb4ade3c35297183d07527640ab8d217fb7f0cf255983d2772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e5083bf52f4e08af54621381b0e86fde18f699565da8915413319b59755c82"
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