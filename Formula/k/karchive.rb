class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.22/karchive-6.22.0.tar.xz"
  sha256 "84254bd0a51ff3d5e2fa22bb946309cec508f1fae726a7aea15149260c4db59d"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "43d90f9bf0e3d6685ff1bc9dd937b8f7cbb5a0cd0bb10db0f7b50c7672de0660"
    sha256 cellar: :any,                 arm64_sequoia: "34226f3696260b35f4545fb39a7cb0f59bafdfc365e0d43d82c1a7286be34a4d"
    sha256 cellar: :any,                 arm64_sonoma:  "2e65fa6789f217db687b2c4952d3f44b15bf0f64407e6c0ba977a06a1d0daf88"
    sha256 cellar: :any,                 sonoma:        "83d30aa4f44fcf2a72a59e7b8627f733586cf43c300e0327d469ed129a9b2abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f6ddedb14cae760e3741f58d1c71b1855d3dc0cb4a5c254c6259f15569a545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6982b4a656d8ecc699ae8571c199fd8e08592f36a7bbc1f963e4e900aeddf797"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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