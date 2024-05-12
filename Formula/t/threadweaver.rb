class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.2/threadweaver-6.2.0.tar.xz"
  sha256 "e74de2df0bb50148acc8a6161f9809991ae4b2334b58a9ee092ba1d827044337"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "31587cd7e9f88608dce595d6f5d146c042eb5153f29d153ba604fa85a73246ff"
    sha256 cellar: :any,                 arm64_ventura:  "c5bf5db1e841dba92336d86d3cf6cf684c3d05f6f545333c778be2770cd8de16"
    sha256 cellar: :any,                 arm64_monterey: "deaa0b918b0f309d63b85016cfaed685bcb41b7f9867131319d7d3697987f6bd"
    sha256 cellar: :any,                 sonoma:         "74dd1db6ef866ecd2da8aa77f0b4255a8ad3d1fad61ec5b53043107d5ab1b340"
    sha256 cellar: :any,                 ventura:        "f996845eddcb3b123131a1183b07ee3f7fd2b9626b15ccb5c3be11e9a29351f6"
    sha256 cellar: :any,                 monterey:       "f8db5ffbeba07c62adc88a74458d7b9a0c6c1e01b6d8d1d854a0dd8d697e0752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16aca6384999b21020d3cb15cd0ca97124a9f836c87d13f266df230da1d4163d"
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