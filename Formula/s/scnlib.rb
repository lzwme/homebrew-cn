class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https:scnlib.dev"
  url "https:github.comeliaskosunenscnlibarchiverefstagsv3.0.0.tar.gz"
  sha256 "4435489aeaf4cdb8f81d0c48c4185e8436d80c57cff3e6cc7d1decd236f62fa6"
  license "Apache-2.0"
  head "https:github.comeliaskosunenscnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "730190d9f70b73d62b5c3d4186f5b47b2ba012c5c832aafc56a124a75c46099b"
    sha256 cellar: :any, arm64_ventura:  "584fbbee0ec2401ca39ea534bcaff880a23b306c013775b1589859b8394c0d48"
    sha256 cellar: :any, arm64_monterey: "2c7b090821076f75c533a97e5d06fc6b0b6001214235d29780f25da01ee64428"
    sha256 cellar: :any, sonoma:         "04788975f9299a1162ac639acecae402094cf3b341a4b7f389648cb74f770ba9"
    sha256 cellar: :any, ventura:        "b4ab1c26817878ccd33cd0ba5428934b2285e2323120741da8d8b74c8e9c305c"
    sha256 cellar: :any, monterey:       "0bd33a5b9ebca24788197953047ff92ec75d593eabd00384e45495da3dce1e93"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSCN_TESTS=OFF
      -DSCN_DOCS=OFF
      -DSCN_EXAMPLES=OFF
      -DSCN_BENCHMARKS=OFF
      -DSCN_BENCHMARKS_BUILDTIME=OFF
      -DSCN_BENCHMARKS_BINARYSIZE=OFF
      -DSCN_USE_EXTERNAL_SIMDUTF=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system ".test"
  end
end