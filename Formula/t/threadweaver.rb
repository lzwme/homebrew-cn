class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.19/threadweaver-6.19.0.tar.xz"
  sha256 "d8d4d0b6e62b067a8ce4fed7aefeed02ed43a43f97f085db3baedf9210070da1"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e57f4a57723719a3b510db93fef405319571a429650c15c2fd2f29e0afcafe3b"
    sha256 cellar: :any,                 arm64_sequoia: "4053492538da7320c29d2cae3227b32181e42197d71b2f180d33e3cabd4ffe30"
    sha256 cellar: :any,                 arm64_sonoma:  "205c22f35dcfb6d0825ddbbbd016d00d4fce6bde3645f7a30d18bcbc6fe4c77c"
    sha256 cellar: :any,                 sonoma:        "15f7854ad687e5c0d62f3af8c027ba321477d0ac3da56fc1d72f8a7c769d2618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bcaff3f5092ac0183ff7d8bb3831991a7829f88e54bf58482515b0f71ea7d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d5074305d348f64cd2e5c605d35a158acf8fd7cd322a63acd6c82f9f945263"
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