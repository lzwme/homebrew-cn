class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://ghfast.top/https://github.com/coin3d/coin/releases/download/v4.0.9/coin-4.0.9-src.tar.gz"
    sha256 "599b561a2ea5dacdc77f544b122b0a985c1c7ff29a37ac4919836cd4f55af283"

    resource "soqt" do
      url "https://ghfast.top/https://github.com/coin3d/soqt/releases/download/v1.6.4/soqt-1.6.4-src.tar.gz"
      sha256 "1387d702df5578fdbc16b9c0a12dd52a68c0478f5e112cb6a45c033f02ba4d24"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ecb2df1bdc0b0d5c8af5ae23e1fb838c77f27df434609e8301b59a6ff35d78c"
    sha256 cellar: :any, arm64_sequoia: "d9b324c3ed0702f5b93d9eac94f9ffbebbc30813b446fae7b795863326d41ea6"
    sha256 cellar: :any, arm64_sonoma:  "9a758890ca8b08fbed41b34454e459a56a590082c1395ddca3f6ba41227957a6"
    sha256 cellar: :any, sonoma:        "607a3c787737178fd6f03959e4579889db18b50f4db0f8bcddb15d92a3aaf4c2"
    sha256 cellar: :any, arm64_linux:   "c05c23e1ed15a924bd1b907f50db7d9bac92207dca9284e2ea90619054012cf5"
    sha256 cellar: :any, x86_64_linux:  "a12fd593ff2f956bccf6494d584c7cded43038cfe73c0f43bf27865a47235c1e"
  end

  head do
    url "https://github.com/coin3d/coin.git", branch: "master"

    resource "soqt" do
      url "https://github.com/coin3d/soqt.git", branch: "master"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "qtbase"

  uses_from_macos "expat"

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def python3
    "python3.13"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DCOIN_BUILD_MAC_FRAMEWORK=OFF",
                    "-DCOIN_BUILD_DOCUMENTATION=ON",
                    "-DCOIN_BUILD_TESTS=OFF",
                    "-DUSE_EXTERNAL_EXPAT=ON",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("soqt").stage do
      system "cmake", "-S", ".", "-B", "_build",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-DSOQT_BUILD_MAC_FRAMEWORK=OFF",
                      "-DSOQT_BUILD_DOCUMENTATION=OFF",
                      "-DSOQT_BUILD_TESTS=OFF",
                      *std_cmake_args(find_framework: "FIRST")
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end
  end

  def caveats
    "The Python bindings (Pivy) are now in the `pivy` formula."
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    CPP

    opengl_flags = if OS.mac?
      ["-Wl,-framework,OpenGL"]
    else
      ["-L#{Formula["mesa"].opt_lib}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"
  end
end