class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https:cppinsights.io"
  url "https:github.comandreasfertigcppinsightsarchiverefstagsv_17.0.tar.gz"
  sha256 "2dd6bcfcdba65c0ed2e1f04ef79d57285186871ad8bd481d63269f3115276216"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96323129186a6544a116c838c12b1f3553afed284acc34f9dab10be492c67931"
    sha256 cellar: :any,                 arm64_ventura:  "2d0955d7f8b5d8755a3e2ac7877561eb447e3cf94ac6675c88c91324047c9ebf"
    sha256 cellar: :any,                 arm64_monterey: "977d8ed27ed1b3fe8435290de94c923c1f8b1466f31899e78debff7b6d610f90"
    sha256 cellar: :any,                 sonoma:         "086658af37dfd1cd02e2964c87ac811aec7878cb248b8184d07cbb52623ae29e"
    sha256 cellar: :any,                 ventura:        "144b6339feb3dda9c22489ca2f4c491cb9f104a19a5d8c7cdea07c0e190cb6aa"
    sha256 cellar: :any,                 monterey:       "0bb503eeef577a4824d930902468acde8b401485c7abe24254734497caf0c6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83984ed67773a0e00370010c90b7d841f32cd7791ff3a53ebf160607177799b"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1300
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if ENV.compiler == :clang && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      int main() {
        int arr[5]{2,3,4};
      }
    EOS
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}insights .test.cpp")
  end
end