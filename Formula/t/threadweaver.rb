class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.8/threadweaver-6.8.0.tar.xz"
  sha256 "8864dd30b7a55f751c1ba81abda789a3934964be18ba1c8e694e2bc48768bfde"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "7ee4a0d056bec3460ed6fbf9a39eb8d8f2822327c68c54c81381d33481020ce4"
    sha256 cellar: :any,                 arm64_ventura: "43b6eb937fe080013c14f7384c78fd05ed3227c20beffe1b9f249c54d60dffe1"
    sha256 cellar: :any,                 sonoma:        "aed5a5ab81699c18587a78cf6234ee61d18d1f6874de8b175886f31c807d5912"
    sha256 cellar: :any,                 ventura:       "849828f864bb17e7d31615fc37414b471fead9ad0c31345b0ea13e066b9c46e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af781797bba2b148c644ea5eb45667039b6b47e0a06caa3a6d06f3f1a1dd0b1"
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