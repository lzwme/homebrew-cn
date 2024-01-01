class Catch2 < Formula
  desc "Modern, C++-native, header-only, test framework"
  homepage "https:github.comcatchorgCatch2"
  url "https:github.comcatchorgCatch2archiverefstagsv3.5.1.tar.gz"
  sha256 "49c3ca7a68f1c8ec71307736bc6ed14fec21631707e1be9af45daf4037e75a08"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7073508175055f09fc4aa93b9e4ef92763c2098e92d5c886b998a36284f0006e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bb9fa32452f5dc643cd800182ec5ab396d90eb80a52b59ae33037c94cde1f83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a3065e894ad75de63860128a9a4f8f1207c7b3749daba3bef06da11e55c371b"
    sha256 cellar: :any_skip_relocation, sonoma:         "84343e106fdb9db6110c30f84742bb62047a6295c8741c1b8f70229568c92c3d"
    sha256 cellar: :any_skip_relocation, ventura:        "4cd4becb4af8dbd89f4c05b3cc20e807804eaf816db07c0b8319822474a88cf8"
    sha256 cellar: :any_skip_relocation, monterey:       "759f52cbc3007e737eb043d7c0dc368e58aec3d23e6dc96e6bd9fd45fdb311b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33dabae4722186336a4a2c6b0a80d4ce78132d892cb3840420a90cad27d463b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <catch2catch_all.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system ".test"
  end
end