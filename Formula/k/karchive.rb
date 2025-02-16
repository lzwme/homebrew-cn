class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.11/karchive-6.11.0.tar.xz"
  sha256 "12fc4ac53591fb1dd81d6c5243b900a6d48066559263fc66eb2f4995ceb9e380"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "3bb61b3cb27ab12e01dac11cc8e104ceb95bf6d4b4c60664eed1abf2fdfa45c9"
    sha256 cellar: :any,                 arm64_ventura: "2ff6943f361554873496b0c4dc4bea927a752541b36b01ff5e7cce0d6d7affe5"
    sha256 cellar: :any,                 sonoma:        "4d2c8653fa60001521ebf2f38876cdb24b9241ad87b14efa2ce04650ab81992f"
    sha256 cellar: :any,                 ventura:       "b75340f59a99d54c8b85e29ba489c8a50b7e3c4563c202326c69bdb2e91e825d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55eaeff4ba3fc2f8298d5de5c87be391fa64f6e8955a8528c7cf8f19324e7b7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qt"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    examples = %w[
      bzip2gzip
      helloworld
      tarlocalfiles
      unzipper
    ]

    examples.each do |example|
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~CMAKE
        cmake_minimum_required(VERSION 3.5)
        \\0
      CMAKE

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_path_exists testpath/"hello.zip"

    system "unzipper/unzipper", "hello.zip"
    assert_path_exists testpath/"world"

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_path_exists testpath/"myFiles.tar.gz"
  end
end