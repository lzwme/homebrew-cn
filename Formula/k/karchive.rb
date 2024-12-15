class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.9/karchive-6.9.0.tar.xz"
  sha256 "246ad8dd2b5fb83df1cb05ff1fd3934f8a52be94d124350f9e6b7c3420e9c474"
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
    sha256 cellar: :any,                 arm64_sonoma:  "e7e3d749f3db079c57081a6f9c4863d8da9fc99bd23f1c5d78520f50b140698e"
    sha256 cellar: :any,                 arm64_ventura: "a7f63d66d3741adce16a408e2314bd6b4d4c7dd1f8f77821127a0f4d7b19521c"
    sha256 cellar: :any,                 sonoma:        "49c2e19c59e375f45ebdc6dd1e2ed9fd59890385429129092b170d97cb04c56c"
    sha256 cellar: :any,                 ventura:       "e47f0cc40b9fe5b27bd9b26f10de4a0ae5951e7ac2a11dd68433ca0da60db901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce71f838fb2d8dcd484d9c29aaccde2a6d768a2d89b2734147c21dc345ddfcd"
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