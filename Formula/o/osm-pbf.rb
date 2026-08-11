class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://ghfast.top/https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ac7aadc57d218a5186076f55255202ec7d0949c7f334b8b0cec8bdd196cd75d7"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd54607b86d474b73a4ce2e35bed4569597cd036544a9753368a534fcdea1c7f"
    sha256 cellar: :any, arm64_sequoia: "f04b85d3b9ba4bf12b64e4c8b0784a08802c03f8580677b9be2ade79564a7aa6"
    sha256 cellar: :any, arm64_sonoma:  "a0eda0e289a50f7da7769e97ca047d761c86f83957362cdb648f28c181916e56"
    sha256 cellar: :any, sonoma:        "b4e210f3bddb9c1bf89bd02d91657ff469cfc4aab796947fd79bc9a65d1a2bf0"
    sha256               arm64_linux:   "cc9d447e276db8b168294cca83d654eaba1eb75083d217cd3dc39407b47bf261"
    sha256               x86_64_linux:  "8e5806cdda66da4e4aee60b6b12db1a8ac68719811a571854522c9a8332c67eb"
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