class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.9/threadweaver-6.9.0.tar.xz"
  sha256 "d249181d21aa89ad6f5108db3b188c25c9415c9834110f8d15f6bab2df39c190"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "2a7a987b6e2ff573a671cad9a3363ed6af740d66916fd016f188b6028ce9a249"
    sha256 cellar: :any,                 arm64_ventura: "e3e29431dc6d2f87409fe6556a91405f50f59c4f7e455b82a73a4bac1079490b"
    sha256 cellar: :any,                 sonoma:        "095ca0b43175c17ee8f12a008ba9e78f143432af5e1d8ad5656cc4f57769d51d"
    sha256 cellar: :any,                 ventura:       "7f9484c0b8ba85abe259ef129c2c9dbd8a36e020ecf52f1cb6e73f049ea2570e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41abf4a91daa0c5cc9e716af715c0eb23751cecfc6ba82de32d393f04a20f333"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/HelloWorld").children, testpath

    kf = "KF#{version.major}"
    (testpath/"CMakeLists.txt").unlink
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(HelloWorld LANGUAGES CXX)
      find_package(ECM REQUIRED NO_MODULE)
      find_package(#{kf}ThreadWeaver REQUIRED NO_MODULE)
      add_executable(ThreadWeaver_HelloWorld HelloWorld.cpp)
      target_link_libraries(ThreadWeaver_HelloWorld #{kf}::ThreadWeaver)
    CMAKE

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end