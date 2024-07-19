class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.4/karchive-6.4.0.tar.xz"
  sha256 "bce4d06384960c6c7c18c86908b2d74c18d8600816c6f15c2920303a4806dabb"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ddad8a7059f1c06beb15fb80ebda4ef2853707b52c3f088ae6a89be8d81a772e"
    sha256 cellar: :any,                 arm64_ventura:  "e117de28e05e661c196ddac23672e2916985bd0d6c3031251a91ee32367dba18"
    sha256 cellar: :any,                 arm64_monterey: "82ea294cdd0f0115429e4f0d2915a752958c3e5e73b75130bae9e5cc3ecc2f2e"
    sha256 cellar: :any,                 sonoma:         "4d902e2d098ce6dd0e772290ddc11404501fa87dc933838085d40c5313562e4b"
    sha256 cellar: :any,                 ventura:        "f8dac97000633ce6117fe7750fb040830c7cc4b15d6b8d6592dc82634aaf7089"
    sha256 cellar: :any,                 monterey:       "ee8ddb13d0cbcf3241ca1b996df298a35203bc2bf9cfdbc56b84242f557cb855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4527c76459b6a2092dba698503840415944f1186b7d903bedba1e343c5a08bb"
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