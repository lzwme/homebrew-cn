class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.11/threadweaver-6.11.0.tar.xz"
  sha256 "c408d9ef3c13e9906e6ef1a162def5bf7459f099197b1788eb3d96df4505dd8f"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "1e547cce3326cd912aca6a44e5981d530b387c0020969e15d905c959717d6505"
    sha256 cellar: :any,                 arm64_ventura: "c4a13acfc8d808e49dee42928d8f2365158c8006d8a5bbea8e74a790044d2330"
    sha256 cellar: :any,                 sonoma:        "6f63bcf2a0d96926348b30542a130b2d666bc4199fc5a46cfe5f94eacf098182"
    sha256 cellar: :any,                 ventura:       "b0da1c6c8c7773b74c3e09f8e39d1fd4dbe9429c081e85ee3ac099d536afe045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e211194a4f1de214ee55f435e00f7ed374296b0d837881eb1000642ba5e9ad9"
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