class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search with KD-trees"
  homepage "https:github.comjlblancocnanoflann"
  url "https:github.comjlblancocnanoflannarchiverefstagsv1.6.2.tar.gz"
  sha256 "c1b8f2e4d32c040249dad14a89dd03c5106a8c56f3e9ca4e60a0836a59259c0c"
  license "BSD-3-Clause"
  head "https:github.comjlblancocnanoflann.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cccc62ea14eed8e68abd6d3cf781f2e78d9356cb45259dd806724adfd582908a"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "gcc" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "https:bugs.llvm.orgshow_bug.cgi?id=23029"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DNANOFLANN_BUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system ".test"
  end
end