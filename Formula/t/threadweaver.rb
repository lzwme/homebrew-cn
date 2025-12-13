class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.21/threadweaver-6.21.0.tar.xz"
  sha256 "3d6f94722ca329f1697e80d8345d96e513047077399bbebb0e3a2cdc177f04e5"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4bcfc5ef96c0744cca5bbcaddac2ab3a88517906746df7735c6ac9e8f03e3f3"
    sha256 cellar: :any,                 arm64_sequoia: "8480b00229f7a788dc28f19e562ef26fe212d8b9cac74c534822df2a75d24249"
    sha256 cellar: :any,                 arm64_sonoma:  "421ea3b3da8bbbaa143c20b38906344e73e5ac1830ac85952457e7f564d83bab"
    sha256 cellar: :any,                 sonoma:        "53212d6d3437c96e65b7594afdfeac2b3e09d72ac6f51d45e6717cc9af83ab20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a24e01f82781e67ac08fe613a0fcdfa851c48607ea652734338ea0e74a4718e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d493f5afd83e018fa60b9e9c21096234521c9a4845e1f3d60ec2b81a266ad5"
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