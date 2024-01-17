class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]

  stable do
    url "https://download.kde.org/stable/frameworks/5.114/karchive-5.114.0.tar.xz"
    sha256 "aa413081eff657576944e2b20df298add063b2a9e99d8b0ec9c8dbac7e60af04"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e58e82837b69a353805dfb32784980f22c4e97cb249fb4f732beca9828801e71"
    sha256 cellar: :any,                 arm64_ventura:  "a7b12ad651e2c265dfa1592378c536cdd04b170e62f3d0f42c226155cacc88e9"
    sha256 cellar: :any,                 arm64_monterey: "6cd3bc877dcfd48b80d92b17a283e8d928a87d2289c9cdcd532574b775f87840"
    sha256 cellar: :any,                 sonoma:         "f41f4d3b028ba8c0ff8d51fe2ae2fa4129b3e57f906c1bd4a9833cf14dad46fc"
    sha256 cellar: :any,                 ventura:        "dd5a68e643539052ca4272b4d83aabbf004e0e89477b742e3d587904d98f1b9a"
    sha256 cellar: :any,                 monterey:       "dc215b768fb40047decab0d2c2b47789a95e1ee8ee495203af325be21aa9bb1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90d4a4257fa7c79f925a0a89a07fec8fce18212cbe446edfec937101ea9df126"
  end

  head do
    url "https://invent.kde.org/frameworks/karchive.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build

  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "cmake", "--build", "."
      end
    end

    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end