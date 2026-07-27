class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ac7aadc57d218a5186076f55255202ec7d0949c7f334b8b0cec8bdd196cd75d7"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9e4e9c59bd0e2e72e88e81cc9af4b1c3837b63cc7b5c423f0b862ff5261133d"
    sha256 cellar: :any, arm64_sequoia: "fdc2726dbd213efb1235e96795e674b0c8c3ef1921fed19c9bfc54e03f63eabd"
    sha256 cellar: :any, arm64_sonoma:  "dfd0ea7de5d8ea4e777425cdedbe18f7f0cb40bafcaef9991fa8451746a190ce"
    sha256 cellar: :any, sonoma:        "1fcbcb1e505ccefbb6bb046b424bc2138074e2a42f0003fe869ed33768690251"
    sha256               arm64_linux:   "995d16ea53c6fae586db82ce9c22962f1b54f6594f2b2f6d2cb24afcbbadbba8"
    sha256               x86_64_linux:  "345f01e0bcc784a7cf96143030b3cf2b3fb7c629ab6080a0d75c3409034de245"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <osmpbf/osmpbf.h>

      int main() {
        OSMPBF::BlobHeader header;
        header.set_type("OSMHeader");
        std::cout << header.type() << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, testpath/"test.cpp",
           "-std=c++17",
           "-I#{include}",
           "-I#{formula_opt_include("protobuf")}",
           "-I#{formula_opt_include("abseil")}",
           "-L#{lib}",
           "-L#{formula_opt_lib("protobuf")}",
           "-L#{formula_opt_lib("abseil")}",
           "-losmpbf",
           "-lprotobuf",
           "-labsl_log_internal_check_op",
           "-labsl_log_internal_message",
           "-o", testpath/"test"

    assert_equal "OSMHeader", shell_output(testpath/"test").chomp
  end
end