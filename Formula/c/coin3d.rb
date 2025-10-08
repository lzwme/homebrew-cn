class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin)"
  homepage "https://coin3d.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://ghfast.top/https://github.com/coin3d/coin/releases/download/v4.0.5/coin-4.0.5-src.tar.gz"
    sha256 "0abc591cb49cbb8d97eb70251340f61cc1bd75a3ac1fa7c23907af6671c1079a"

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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "00913f751a45abbac7e226ec57996dca60ef8c5ffaf174961210f2e3486c9f46"
    sha256 cellar: :any,                 arm64_sequoia: "76d0ae79918784f18c79e3148c919516ade76ee681ae05145eca1c76b4c6ea95"
    sha256 cellar: :any,                 arm64_sonoma:  "d413285777da406be2ca5a63640c0a5fe1c9de4106cb070319e76099d2e5d3dd"
    sha256 cellar: :any,                 sonoma:        "f87eaf2b4565796ac4167a98383f041367242b8159e5101f8a930ed69296e658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f75296237d2e535a06e7851d3030d2d6715692b4dda2d5dbabfc84fdf338c6a5"
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