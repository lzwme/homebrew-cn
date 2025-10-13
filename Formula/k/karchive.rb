class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/karchive-index.html"
  url "https://download.kde.org/stable/frameworks/6.19/karchive-6.19.0.tar.xz"
  sha256 "944332d802d0e128cebd087ffd50b726d100347973c2037c6051c72d54512a9e"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e82e955c89176c9ee1a7ec518f220abd098259fb8ae36c261f2e883e44df03a8"
    sha256 cellar: :any,                 arm64_sequoia: "d52d5da9d590d81f0b2721cfe5eacadfec4fe7a7796868cdfde65c781dd9cbce"
    sha256 cellar: :any,                 arm64_sonoma:  "59b41943fa00da8ccd4f943a7324f9d6a7b31714c037afdc3544752dc03c60f5"
    sha256 cellar: :any,                 sonoma:        "b6e0030e3fc256cbfa655141eef55481e9bda6bd9d5e549204122a35a0d3c6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42fe6995f88bb567c92be31d1c3db4eed0c7efaf7f3d618edd23457c358abbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cbe5429a25ee1d5598f60a911d53a36144ca33bbb7b88adac6bb798013ff7b"
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