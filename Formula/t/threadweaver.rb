class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.111/threadweaver-5.111.0.tar.xz"
  sha256 "8b1b6ceb38d3f3b32cead7ff8883dab3521cdca0ece8cc8e10ad6d59b46db766"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4697e1e0cc6c76ece3573532821859e303f35c6f1b3627c5b1917d59bbfbbc22"
    sha256 cellar: :any,                 arm64_ventura:  "f4a9c2d9b6e82ad48ebe07233332a60b4513a33391e1a2ab9670fd60d952cefa"
    sha256 cellar: :any,                 arm64_monterey: "7a80c5fa34f3684778592e3feae230e2d7400287b911517322348a6f80600f54"
    sha256 cellar: :any,                 sonoma:         "ac77999ec2161271cdee6e2f0e370e862f7ba133a9cfaaba7f5efd5e9dad1260"
    sha256 cellar: :any,                 ventura:        "6b5f00906219ab0775d0d5d9fd76209633ba1eb02e7737cc3dedc209b48d57fd"
    sha256 cellar: :any,                 monterey:       "ae498685cf8751ecc0da8c77b129eab38ebb5cf6c87fd55e4a50cd9ae31d994b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc85c24148141ff4623e7470e0fcf84118aa368c2da178d3d2ba97104b917507"
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