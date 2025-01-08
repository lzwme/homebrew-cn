class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search with KD-trees"
  homepage "https:github.comjlblancocnanoflann"
  url "https:github.comjlblancocnanoflannarchiverefstagsv1.6.3.tar.gz"
  sha256 "6140542c30b4abd6a6ffe52c591afaae5748f011c65682d1cae6c501e7e6710a"
  license "BSD-3-Clause"
  head "https:github.comjlblancocnanoflann.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45e50c064255d59875d4386f3778b70d0e8ccc1186a7b358d710e48b1cda9f92"
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