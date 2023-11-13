class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.112/threadweaver-5.112.0.tar.xz"
  sha256 "c91de5489d3f660a177fa91cb24827d7e316827fa6f3d290bb656be0b09178c4"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8e1c6b92b79af83a3bb0d40fd0ea7f184dbde1e8b275b6634eeeccf55b6e658c"
    sha256 cellar: :any,                 arm64_ventura:  "401f4ce3620d59ca5ef80d5ebff6cb991cae858adb41df737a3e104a1c804881"
    sha256 cellar: :any,                 arm64_monterey: "fb84d6c1fce9b5e2dc16d75590d2f2973fe7255b3a3d7754fa1add85399f2fc9"
    sha256 cellar: :any,                 sonoma:         "0945d665454e77c826727a0e9d623bb1abe208ae88af63d23177a890b272a4cd"
    sha256 cellar: :any,                 ventura:        "f5401a274e67db05b3d926b0a842d655c067167e727ee2a2e9a474ebf3b57c75"
    sha256 cellar: :any,                 monterey:       "83dcf9f477229f87fa324b234bc2301309593351f51107270b7ec1f5d948d4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb4f8e1c4ac415522eca5a97ed6f39ae4f759958247244ca8bf3072aa609981a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    qt5_args = ["-DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core"]
    qt5_args << "-DCMAKE_BUILD_RPATH=#{Formula["qt@5"].opt_lib};#{lib}" if OS.linux?
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, *qt5_args
    system "cmake", "--build", "."

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end