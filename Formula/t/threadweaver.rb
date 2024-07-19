class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.4/threadweaver-6.4.0.tar.xz"
  sha256 "a317ad5b4e0ae8dee7fd95026a3df3f5fc1c2e53aec6d5ccbadddfc753c29598"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a65d015c21a457c3054371db7a81d6d7e27bc806e7432b05d2dcff461f9c772"
    sha256 cellar: :any,                 arm64_ventura:  "91318871c9ed93fff1e0e2d6dcf1df6e16cee9d7ec227d54f11fb46d926b7f76"
    sha256 cellar: :any,                 arm64_monterey: "d3fa0d5d46dfb9f6eac434d4b5d1d6eca16c71590124ed18bac6bd0ff2d940df"
    sha256 cellar: :any,                 sonoma:         "e7e2323f078848a85aeb16b687dbada0553bc6b3107b45f71bda619803c78aef"
    sha256 cellar: :any,                 ventura:        "7583ad8a6a368f0a1b1f6b926e5bfaf092d20293e86d898ac27341b8c479fe9b"
    sha256 cellar: :any,                 monterey:       "bfc71a4487c6b31b2d17f8d8cb96f5cd82c5183f0efdbd2e6d74d626162e1341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d609a02e5f360d9fbb6249dbd08d39e6b628181de7c99431d9f36bbe7aeb9b6d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  fails_with gcc: "5"

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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(HelloWorld LANGUAGES CXX)
      find_package(ECM REQUIRED NO_MODULE)
      find_package(#{kf}ThreadWeaver REQUIRED NO_MODULE)
      add_executable(ThreadWeaver_HelloWorld HelloWorld.cpp)
      target_link_libraries(ThreadWeaver_HelloWorld #{kf}::ThreadWeaver)
    EOS

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end