class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.111/karchive-5.111.0.tar.xz"
  sha256 "e00e3d492882788e4289d62c6bde25e56178197de92f232a5850864ff6c2cd2d"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ba76718f084c3b40914ba8f59aa8879a968e5c634f830b4f1f90bc94bc97a0fa"
    sha256 cellar: :any,                 arm64_ventura:  "d2ff2e96a20c058ea07576101605e8eb8c68be3ee1d4763ad27acb9250fd982f"
    sha256 cellar: :any,                 arm64_monterey: "d48097f5e9a975f198ea20ce98746f17124aee5a8a33b299be31ad42ef7cdbe0"
    sha256 cellar: :any,                 sonoma:         "783079c7eb74e8661486ce56e0e9877cf7280a984d6894dadacbaac0ff152662"
    sha256 cellar: :any,                 ventura:        "64cf8bf06731b712556f1187b81fdf48ae057ead94b90bfcaf64150d9922ea4a"
    sha256 cellar: :any,                 monterey:       "7fd7b7f098b93e7b5a81f57bc01998a14edddd6b6eaab11ef7bc96a3918900a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab9328f96df2d507a9a702d5b835dc60ed69e969f6f5f1585625d438cd115a93"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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