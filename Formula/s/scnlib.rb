class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https:scnlib.dev"
  url "https:github.comeliaskosunenscnlibarchiverefstagsv2.0.0.tar.gz"
  sha256 "2a35356a3a7485fdf97f28cfbea52db077cf4e7bab0a5a0fc3b04e89630334cd"
  license "Apache-2.0"
  head "https:github.comeliaskosunenscnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "160139345f1ecb71a4889408a553348e3ff757bc993f2fa4ee7d44ef6ee5dafc"
    sha256 cellar: :any, arm64_ventura:  "a857e39ca2054beafbf8cfd7ce6129388e2dc605cd64fc3e749edf04e603a37b"
    sha256 cellar: :any, arm64_monterey: "10043eb4a407068ae0da43190e5843d11c2eaea9057d6528039b0b790979feed"
    sha256 cellar: :any, sonoma:         "4563ca716a5975eb0404539ff69d1c7547a4befeba314109c46d2dc598617720"
    sha256 cellar: :any, ventura:        "2296167e227d5ebbc935b7bfc3a35a67925333f422b9512b33161740241e3a16"
    sha256 cellar: :any, monterey:       "41e1e7238c0d60fd61a09294a3629fe811abc13f2e2e5f3f720b9bcac0280671"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSCN_TESTS=OFF",
                    "-DSCN_DOCS=OFF",
                    "-DSCN_EXAMPLES=OFF",
                    "-DSCN_BENCHMARKS=OFF",
                    "-DSCN_BENCHMARKS_BUILDTIME=OFF",
                    "-DSCN_BENCHMARKS_BINARYSIZE=OFF",
                    "-DSCN_USE_EXTERNAL_SIMDUTF=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <scnscan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cxx, "-std=c++17",
                    "test.cpp",
                    "-o", "test",
                    "-I#{include}",
                    "-L#{lib}",
                    "-lscn"
    system ".test"
  end
end