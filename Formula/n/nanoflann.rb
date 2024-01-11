class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search with KD-trees"
  homepage "https:github.comjlblancocnanoflann"
  url "https:github.comjlblancocnanoflannarchiverefstagsv1.5.4.tar.gz"
  sha256 "a7f64d0bdff42614c561e52680b16de46c0edac9719f21f935c5e1f8b0654afc"
  license "BSD-3-Clause"
  head "https:github.comjlblancocnanoflann.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d60d9dbdc431b9ae7e541c55b5a8217647d1931e32652f0fa8879b94aec1e562"
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
    (testpath"test.cpp").write <<~EOS
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system ".test"
  end
end