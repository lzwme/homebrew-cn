class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.2/karchive-6.2.0.tar.xz"
  sha256 "1435e09e64bf4cf27ceebfc76582e44db9d37b1453e55aeee09778bccfd9a8b2"
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
    sha256 cellar: :any,                 arm64_sonoma:   "c416fec09158ef253da03c7bf73a12ab3f1a5520d14c54622c9876c4760d580d"
    sha256 cellar: :any,                 arm64_ventura:  "76f1418e8b499dc9c040e7bbfc3878137270350275858c8d8b3fa8ec7dfbe07b"
    sha256 cellar: :any,                 arm64_monterey: "4d5bce9f3ea1f199fad74544b35f69eef4c842cb23c055d148404815e2fcc95a"
    sha256 cellar: :any,                 sonoma:         "3b62ea98c315b1240568d9428f4836efa4d1df03bed9f5ab34e5b10fb0ee76c1"
    sha256 cellar: :any,                 ventura:        "fcbe7504f930b79849d8bde560eb1e17054507bd99e0773e2a2ff90994e4303f"
    sha256 cellar: :any,                 monterey:       "5ae43a64523d3e9638803c5314e760f5e1c45e85c994d68873d47288cac21d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a37056d43b4187ccaa283040c3afc039faf62a0ec64cfb85adbea57bab45fc7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "qt"
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
    cp_r (pkgshare/"examples").children, testpath

    examples = %w[
      bzip2gzip
      helloworld
      tarlocalfiles
      unzipper
    ]

    examples.each do |example|
      inreplace testpath/example/"CMakeLists.txt", /^project\(/, <<~EOS
        cmake_minimum_required(VERSION 3.5)
        \\0
      EOS

      system "cmake", "-S", example, "-B", example, *std_cmake_args
      system "cmake", "--build", example
    end

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "The whole world inside a hello.", shell_output("helloworld/helloworld 2>&1")
    assert_predicate testpath/"hello.zip", :exist?

    system "unzipper/unzipper", "hello.zip"
    assert_predicate testpath/"world", :exist?

    system "tarlocalfiles/tarlocalfiles", "world"
    assert_predicate testpath/"myFiles.tar.gz", :exist?
  end
end