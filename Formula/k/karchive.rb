class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.21/karchive-6.21.0.tar.xz"
  sha256 "a5f7ccd904105083c442bc825c198872bdb7a009b2b2bb30b038dabd6bb1c6c4"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4594a22058e9b3826feba58ab869cc89c51ba5eef28a7db87e25a88f1d681c0e"
    sha256 cellar: :any,                 arm64_sequoia: "ab3a1791f2ec6e5e3c0d3f5c4f6ba55cdd1b50df848c09a1480764f738f7f163"
    sha256 cellar: :any,                 arm64_sonoma:  "d1b616673966e132d01fd3abfa8743eb3d7b65995eaded65dd8d83e73713fdb9"
    sha256 cellar: :any,                 sonoma:        "29237ceafb3b07cf4e72d01f8bdbb4e4f5b6729743a350f74acae4fc9eb7cb68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5af077a1f56d438abc85b8836cb1974a447f2fb63539780b0f30fd7de95dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6ba5822958b1fbcffc0c037d611e64290852738de5c997871db7932447b5847"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "openssl@3"
  depends_on "qtbase"
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
        cmake_minimum_required(VERSION 4.0)
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