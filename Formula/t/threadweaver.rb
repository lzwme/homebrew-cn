class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.18/threadweaver-6.18.0.tar.xz"
  sha256 "a6e7f4c90b9b9304ef67a0fffadd77655757c65f7bee00c35b38aefc869e3278"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "38b2dff08333f4124a05939da8ad519720dd9cc4f24399bf196601a1e24c17e4"
    sha256 cellar: :any,                 arm64_sequoia: "90d2240578f73603cbc243f0d0c964731c258e0a6604b113b7f831c8c474e852"
    sha256 cellar: :any,                 arm64_sonoma:  "1b414830699e19e1868fffbb93569f5b74a15d1b6658c1cdf3bfa9188fa882f5"
    sha256 cellar: :any,                 sonoma:        "1d3bfc910f2b04ae1cd2630be462a0875576ae4ec583a7e2b5b2d4d6a91bd26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96c49bfc14531816d270de03569a10b335147092ec8c7adeb5e68f0201dc3d4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qttools" => :build
  depends_on "qtbase"

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