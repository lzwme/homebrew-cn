class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.6/threadweaver-6.6.0.tar.xz"
  sha256 "19555488abf05a9d5a1641f165a67d347e23ab7d14c6f9464ffcf8db2370317a"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "61be8c1a345cacc41e7f1c1ca87646ef7db488c38dce76258ef1709b39454f10"
    sha256 cellar: :any,                 arm64_ventura: "0445f7a5ea6110d484498a6ff9adba4a73088daba17ec0ca558e59d05ffdc846"
    sha256 cellar: :any,                 sonoma:        "3c7827ce581a092c0119023135a535640653c603057c81f9fb4123c25fd5ad66"
    sha256 cellar: :any,                 ventura:       "4fa921e81a293f0980bf0c2adbd3616271f10d627b5ed8dda26001e79209847f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1abc9d34f3498ae5ba5ad93559513bec88752082247fa18dac10e3bb0bbbfe"
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