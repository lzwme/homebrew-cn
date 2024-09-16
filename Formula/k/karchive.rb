class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.6/karchive-6.6.0.tar.xz"
  sha256 "51e9d21cb87e2241bca6a69e1496661d05d00a581107bfcf9859aa9e70acac1b"
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
    sha256 cellar: :any,                 arm64_sonoma:  "30064be1d9ace083ec79879d561cca1f3e89d291d5f2ca2956b4cf13611be7c1"
    sha256 cellar: :any,                 arm64_ventura: "cd63406e59b7eddfded438dadea826c86b05c6d94b6924d4edb2b69e5e88b82d"
    sha256 cellar: :any,                 sonoma:        "33ce45e0b463ecb0eb1dc7c0dc599e9c1ecc32224aa03d9ce62bf2033c88d19a"
    sha256 cellar: :any,                 ventura:       "8f02640d8b73537cab8d999584224b11138ad4c86d240cafdf9bcc2bb7cc9e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f65f64d2e825e02a9bec1c8e4a25489884d596fd97ca0b62aab90605f7ba174"
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