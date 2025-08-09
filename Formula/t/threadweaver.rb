class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.17/threadweaver-6.17.0.tar.xz"
  sha256 "771ff89c1c012a3ea2baed58c803ecd7e8b0b8928e3aebc11c07df5ccf054f44"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8b9587aa58346814f4ff16d9c2461f3bb8ec787787463ce806e8fecbab0a681a"
    sha256 cellar: :any,                 arm64_ventura: "1bcf482d6ea08e54ee7956cd174743c0ad9dc2563b24d12aff99f7b90d350ff5"
    sha256 cellar: :any,                 sonoma:        "56fab6f4212fa8b8228a172b0676597b8f316e77a7221f3fa82171ffa0c37ed8"
    sha256 cellar: :any,                 ventura:       "488009f61ab19421ee4bfac865633d336b6ef120aa1bf7593e57079929f6f580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a079ba9ad54797d11947b92e825b497131a91e3dffbf16955ff0c412fa536bcf"
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