class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://ghfast.top/https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.56.4.tar.gz"
  sha256 "02196a19a75ffde048b04ea8c6a1dae6b2c5b7cf03888bd3e97c6c15994f631b"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40532152f81040c3b11629568dbd4be12bc837768991712f7ca1e81da61f472e"
    sha256 cellar: :any,                 arm64_sonoma:  "b61370f5a9d4bf6275135b2be7e5d3f87378c3f92e11605de576c4075dc693a1"
    sha256 cellar: :any,                 arm64_ventura: "31bea4b726bca6ab8a75982a71629cd0c6c799e4156b8150710dd17e365b894b"
    sha256 cellar: :any,                 sonoma:        "52730c674cee0ee3cbce58de07aee551de3a7202758d8289baeb6359fbf43a24"
    sha256 cellar: :any,                 ventura:       "9dbbc89ad165a05ac543ab69ca1d654f195b0c08d5a4e7f89ab5a5737a68340c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ddfefea3c1c678a4cbb038738434560740e5d395fe8c0fd381fed9bf19abe5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd9699b7693eff688c57fb4f3c0d6fd7f462e4872d9cd2df0f1d72d7db781e7"
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